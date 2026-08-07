import { useEffect, useMemo, useRef, useState } from "react";
import { FORMAL_GRAPH_STATUS, GRAPH_STATUS, graphIndex, graphStatusLabel, type GraphStatusCode } from "../lib";
import type { DashboardBundle } from "../types";

const PIBASE_STATUS_CLASS: Record<number, string> = {
  0: "diagonal",
  1: "explicit-true",
  2: "derived-true",
  3: "false",
  4: "independent",
  5: "unclassified",
};

export type MatrixView = "formalized" | "pibase";

function statusClass(view: MatrixView, state: GraphStatusCode): string {
  if (view === "formalized") {
    if (state === 1) return "formal-direct";
    if (state === 2) return "formal-derived";
    if (state === 5) return "unformalized";
  }
  return PIBASE_STATUS_CLASS[state];
}

interface MatrixSelection {
  sourceIndex: number;
  targetIndex: number;
}

export default function Matrix({
  bundle,
  selectedSource,
  selectedTarget,
  onSelect,
  outcomes,
  view,
  compact = false,
}: {
  bundle: DashboardBundle;
  selectedSource: string;
  selectedTarget: string;
  onSelect: (source: string, target: string) => void;
  outcomes: Uint8Array;
  view: MatrixView;
  compact?: boolean;
}) {
  const wrapperRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [hover, setHover] = useState<MatrixSelection | null>(null);
  const [side, setSide] = useState(520);
  const properties = bundle.data.properties;
  const size = bundle.data.graph.size;
  const sourceIndex = properties.findIndex((item) => item.id === selectedSource);
  const targetIndex = properties.findIndex((item) => item.id === selectedTarget);

  useEffect(() => {
    const wrapper = wrapperRef.current;
    if (!wrapper) return;
    const observer = new ResizeObserver(([entry]) => {
      const max = compact ? 520 : 760;
      setSide(Math.max(280, Math.min(max, Math.floor(entry.contentRect.width))));
    });
    observer.observe(wrapper);
    return () => observer.disconnect();
  }, [compact]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ratio = window.devicePixelRatio || 1;
    canvas.width = Math.floor(side * ratio);
    canvas.height = Math.floor(side * ratio);
    canvas.style.width = "100%";
    canvas.style.height = "auto";
    const context = canvas.getContext("2d");
    if (!context) return;
    context.setTransform(ratio, 0, 0, ratio, 0, 0);
    const styles = getComputedStyle(document.documentElement);
    const colors: Record<number, string> = {
      0: styles.getPropertyValue("--graph-diagonal").trim(),
      1: styles.getPropertyValue(view === "formalized" ? "--graph-formal-direct" : "--graph-explicit").trim(),
      2: styles.getPropertyValue(view === "formalized" ? "--graph-formal-derived" : "--graph-derived").trim(),
      3: styles.getPropertyValue("--graph-false").trim(),
      4: styles.getPropertyValue("--graph-independent").trim(),
      5: styles.getPropertyValue(view === "formalized" ? "--graph-unformalized" : "--graph-unclassified").trim(),
    };
    const cell = side / size;
    context.fillStyle = styles.getPropertyValue("--surface").trim();
    context.fillRect(0, 0, side, side);
    for (let row = 0; row < size; row += 1) {
      for (let column = 0; column < size; column += 1) {
        const state = outcomes[graphIndex(size, row, column)];
        context.fillStyle = colors[state];
        context.fillRect(column * cell, row * cell, Math.ceil(cell), Math.ceil(cell));
      }
    }
    if (sourceIndex >= 0 && targetIndex >= 0) {
      context.strokeStyle = styles.getPropertyValue("--ink").trim();
      context.lineWidth = 1.5;
      context.strokeRect(targetIndex * cell + 0.5, sourceIndex * cell + 0.5, Math.max(2, cell), Math.max(2, cell));
      context.globalAlpha = 0.35;
      context.beginPath();
      context.moveTo(0, (sourceIndex + 0.5) * cell);
      context.lineTo(side, (sourceIndex + 0.5) * cell);
      context.moveTo((targetIndex + 0.5) * cell, 0);
      context.lineTo((targetIndex + 0.5) * cell, side);
      context.stroke();
      context.globalAlpha = 1;
    }
  }, [outcomes, side, size, sourceIndex, targetIndex, view]);

  const active = hover ?? (sourceIndex >= 0 && targetIndex >= 0 ? { sourceIndex, targetIndex } : null);
  const activeSummary = useMemo(() => {
    if (!active) return null;
    const state = outcomes[graphIndex(size, active.sourceIndex, active.targetIndex)] as GraphStatusCode;
    return {
      source: properties[active.sourceIndex],
      target: properties[active.targetIndex],
      state,
    };
  }, [active, outcomes, properties, size]);

  const statusLabels = view === "formalized" ? FORMAL_GRAPH_STATUS : GRAPH_STATUS;
  const legendCodes: GraphStatusCode[] = view === "formalized" ? [1, 2, 5] : [1, 2, 3, 4, 5];

  function pointerSelection(event: React.MouseEvent<HTMLCanvasElement>): MatrixSelection {
    const rect = event.currentTarget.getBoundingClientRect();
    return {
      sourceIndex: Math.max(0, Math.min(size - 1, Math.floor(((event.clientY - rect.top) / rect.height) * size))),
      targetIndex: Math.max(0, Math.min(size - 1, Math.floor(((event.clientX - rect.left) / rect.width) * size))),
    };
  }

  return (
    <div className="matrix" ref={wrapperRef}>
      <div className="matrix-axis matrix-axis-y">Hypothesis ↓</div>
      <canvas
        ref={canvasRef}
        className="matrix-canvas"
        onPointerMove={(event) => setHover(pointerSelection(event))}
        onPointerLeave={() => setHover(null)}
        onClick={(event) => {
          const next = pointerSelection(event);
          onSelect(properties[next.sourceIndex].id, properties[next.targetIndex].id);
        }}
        role="img"
        aria-label={`${view === "formalized" ? "Formalized implication" : "π-Base implication"} matrix with ${size} properties. Rows are hypotheses and columns are conclusions.`}
      />
      <div className="matrix-axis matrix-axis-x">Conclusion →</div>
      <div className="matrix-readout" aria-live="polite">
        {activeSummary && (
          <>
            <span className={`matrix-swatch graph-${statusClass(view, activeSummary.state)}`} aria-hidden="true" />
            <strong>{activeSummary.source.shortId}</strong>
            <span>⇒</span>
            <strong>{activeSummary.target.shortId}</strong>
            <span>{view === "formalized"
              ? statusLabels[activeSummary.state].label
              : graphStatusLabel(bundle.data, activeSummary.state, activeSummary.source.id, activeSummary.target.id)}</span>
          </>
        )}
      </div>
      <div className="matrix-legend" aria-label="Matrix legend">
        {legendCodes.map((code) => (
          <span key={code}>
            <i className={`matrix-swatch graph-${statusClass(view, code)}`} aria-hidden="true" />
            {statusLabels[code].label}
          </span>
        ))}
      </div>
    </div>
  );
}
