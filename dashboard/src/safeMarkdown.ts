import { marked, Renderer } from "marked";

const LINK_PROTOCOLS = new Set(["http:", "https:", "mailto:"]);
const IMAGE_PROTOCOLS = new Set(["http:", "https:"]);
const URL_BASE = "https://pibase.invalid/";

function escapeHtml(value: string): string {
  return value.replace(/[&<>"']/g, (character) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;",
  })[character]!);
}

function safeUrl(value: string, protocols: ReadonlySet<string>): string | null {
  const candidate = value.trim();
  if (!candidate) return null;
  try {
    return protocols.has(new URL(candidate, URL_BASE).protocol) ? candidate : null;
  } catch {
    return null;
  }
}

export function safeLinkHref(value: string): string | null {
  return safeUrl(value, LINK_PROTOCOLS);
}

const renderer = new Renderer();

// Raw HTML is data, not presentation. Dropping it also preserves the existing
// semantics of catalog HTML comments instead of exposing their hidden bodies.
renderer.html = () => "";

renderer.link = function ({ href, title, tokens }) {
  const label = this.parser.parseInline(tokens);
  const safeHref = safeLinkHref(href);
  if (safeHref === null) return label;
  const titleAttribute = title === null || title === undefined
    ? ""
    : ` title="${escapeHtml(title)}"`;
  return `<a href="${escapeHtml(safeHref)}"${titleAttribute}>${label}</a>`;
};

renderer.image = ({ href, title, text }) => {
  const safeHref = safeUrl(href, IMAGE_PROTOCOLS);
  if (safeHref === null) return escapeHtml(text);
  const titleAttribute = title === null || title === undefined
    ? ""
    : ` title="${escapeHtml(title)}"`;
  return `<img src="${escapeHtml(safeHref)}" alt="${escapeHtml(text)}"${titleAttribute}>`;
};

export function renderSafeMarkdown(text: string, inline = false): string {
  const rendered = inline
    ? marked.parseInline(text, { renderer })
    : marked.parse(text, { renderer });
  if (typeof rendered !== "string") {
    throw new Error("Markdown rendering unexpectedly became asynchronous");
  }
  return rendered;
}
