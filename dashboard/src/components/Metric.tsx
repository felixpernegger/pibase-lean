import type { ReactNode } from "react";

export default function Metric({
  label,
  value,
  detail,
  tone = "neutral",
  icon,
}: {
  label: string;
  value: string;
  detail: string;
  tone?: string;
  icon?: ReactNode;
}) {
  return (
    <article className={`metric metric-${tone}`}>
      <div className="metric-heading">
        <span>{label}</span>
        {icon}
      </div>
      <strong>{value}</strong>
      <p>{detail}</p>
    </article>
  );
}
