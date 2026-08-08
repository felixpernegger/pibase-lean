import renderMathInElement from "katex/contrib/auto-render";
import { marked } from "marked";
import { memo, useLayoutEffect, useMemo, useRef } from "react";
import "katex/dist/katex.min.css";

function MathText({ text, inline = false }: { text: string; inline?: boolean }) {
  const ref = useRef<HTMLDivElement>(null);
  const html = useMemo(() => {
    if (inline) return String(marked.parseInline(text));
    return String(marked.parse(text));
  }, [inline, text]);

  useLayoutEffect(() => {
    if (!ref.current) return;
    renderMathInElement(ref.current, {
      delimiters: [
        { left: "$$", right: "$$", display: true },
        { left: "$", right: "$", display: false },
      ],
      throwOnError: false,
    });
  });

  return <div ref={ref} className={`math-text${inline ? " math-inline" : ""}`} dangerouslySetInnerHTML={{ __html: html }} />;
}

export default memo(MathText);
