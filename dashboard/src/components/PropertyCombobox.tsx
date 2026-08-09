import { Search, X } from "lucide-react";
import { useEffect, useId, useMemo, useState } from "react";
import { formatNumber, plainMathLabel } from "../lib";
import type { PropertyNode } from "../types";

const RESULT_LIMIT = 8;

function optionLabel(property: PropertyNode): string {
  return `${property.shortId} · ${plainMathLabel(property.name)}`;
}

function matchScore(property: PropertyNode, query: string): number | null {
  if (!query) return 0;
  const id = property.shortId.toLowerCase();
  const names = [property.name, plainMathLabel(property.name), ...property.aliases]
    .map((value) => value.toLowerCase());
  const label = optionLabel(property).toLowerCase();
  if (id === query) return 0;
  if (id.startsWith(query)) return 1;
  if (names.some((name) => name === query)) return 2;
  if (names.some((name) => name.startsWith(query))) return 3;
  if (label.includes(query) || names.some((name) => name.includes(query))) return 4;
  return null;
}

export default function PropertyCombobox({
  id,
  label,
  value,
  properties,
  optionCounts,
  placeholder = "Search P-number or name",
  clearable = false,
  onChange,
}: {
  id: string;
  label: string;
  value: string;
  properties: PropertyNode[];
  optionCounts?: ReadonlyMap<string, number>;
  placeholder?: string;
  clearable?: boolean;
  onChange: (value: string) => void;
}) {
  const listId = `${id}-${useId().replace(/:/g, "")}-results`;
  const selected = properties.find((property) => property.id === value);
  const selectedLabel = selected ? optionLabel(selected) : "";
  const [query, setQuery] = useState(selectedLabel);
  const [open, setOpen] = useState(false);
  const [activeIndex, setActiveIndex] = useState(0);

  useEffect(() => {
    setQuery(selectedLabel);
  }, [selectedLabel]);

  const results = useMemo(() => {
    const normalized = query.trim().toLowerCase();
    return properties
      .map((property) => ({
        property,
        count: optionCounts?.get(property.id) ?? 0,
        score: matchScore(property, normalized),
      }))
      .filter((item): item is { property: PropertyNode; count: number; score: number } => (
        item.score !== null && (!optionCounts || item.count > 0)
      ))
      .sort((left, right) => (
        left.score - right.score
        || (optionCounts ? right.count - left.count : 0)
        || Number(left.property.shortId.slice(1)) - Number(right.property.shortId.slice(1))
      ))
      .slice(0, RESULT_LIMIT)
      .map((item) => item.property);
  }, [optionCounts, properties, query]);

  useEffect(() => {
    setActiveIndex((current) => Math.min(current, Math.max(results.length - 1, 0)));
  }, [results.length]);

  function choose(property: PropertyNode) {
    setQuery(optionLabel(property));
    setOpen(false);
    setActiveIndex(0);
    onChange(property.id);
  }

  return (
    <div className="property-combobox">
      <label htmlFor={id}>{label}</label>
      <div className={`property-search-input${clearable && value ? " has-clear" : ""}`}>
        <Search size={15} aria-hidden="true" />
        <input
          id={id}
          data-testid={id}
          type="search"
          role="combobox"
          autoComplete="off"
          spellCheck={false}
          aria-autocomplete="list"
          aria-expanded={open}
          aria-controls={listId}
          aria-activedescendant={open && results.length ? `${listId}-${activeIndex}` : undefined}
          value={query}
          placeholder={placeholder}
          onFocus={(event) => {
            event.currentTarget.select();
            setOpen(true);
          }}
          onChange={(event) => {
            setQuery(event.target.value);
            setActiveIndex(0);
            setOpen(true);
          }}
          onBlur={() => {
            setOpen(false);
            setQuery(selectedLabel);
          }}
          onKeyDown={(event) => {
            if (event.key === "ArrowDown") {
              event.preventDefault();
              setOpen(true);
              setActiveIndex((current) => Math.max(0, Math.min(current + 1, results.length - 1)));
            } else if (event.key === "ArrowUp") {
              event.preventDefault();
              setActiveIndex((current) => Math.max(current - 1, 0));
            } else if (event.key === "Enter" && open && results[activeIndex]) {
              event.preventDefault();
              choose(results[activeIndex]);
            } else if (event.key === "Escape") {
              setOpen(false);
              setQuery(selectedLabel);
            }
          }}
        />
        {clearable && value && (
          <button
            type="button"
            className="property-search-clear"
            aria-label={`Clear ${label.toLowerCase()}`}
            data-tooltip={`Clear ${label.toLowerCase()}`}
            onMouseDown={(event) => event.preventDefault()}
            onClick={() => {
              setQuery("");
              setOpen(true);
              setActiveIndex(0);
              onChange("");
            }}
          >
            <X size={14} aria-hidden="true" />
          </button>
        )}
      </div>
      {open && (
        <div className="property-results" id={listId} role="listbox" aria-label={`${label} matches`}>
          {results.map((property, index) => (
            <div
              id={`${listId}-${index}`}
              key={property.id}
              role="option"
              aria-selected={index === activeIndex}
              className={index === activeIndex ? "is-active" : undefined}
              onMouseDown={(event) => event.preventDefault()}
              onMouseEnter={() => setActiveIndex(index)}
              onClick={() => choose(property)}
            >
              <code>{property.shortId}</code>
              <span>{plainMathLabel(property.name)}</span>
              {(optionCounts || property.aliases.length > 0) && (
                <small>
                  {optionCounts && `${formatNumber(optionCounts.get(property.id) ?? 0)} pairs`}
                  {optionCounts && property.aliases.length > 0 && " · "}
                  {property.aliases.slice(0, 2).join(" · ")}
                </small>
              )}
            </div>
          ))}
          {!results.length && <p className="property-results-empty">No matching property</p>}
        </div>
      )}
    </div>
  );
}
