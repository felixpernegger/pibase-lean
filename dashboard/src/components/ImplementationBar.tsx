import { formatNumber, formatPercent } from "../lib";

export default function ImplementationBar({
  label,
  implemented,
  total,
  totalLabel = `${formatNumber(total)} total in π-Base`,
  implementedLabel = "Formalized in Lean",
  remainingLabel = "Not yet formalized",
  trackLabel = `${label} formalization coverage against π-Base`,
}: {
  label: string;
  implemented: number;
  total: number;
  totalLabel?: string;
  implementedLabel?: string;
  remainingLabel?: string;
  trackLabel?: string;
}) {
  const remaining = Math.max(total - implemented, 0);
  const implementedWidth = total > 0 ? (implemented / total) * 100 : 0;
  const remainingWidth = total > 0 ? (remaining / total) * 100 : 0;

  return (
    <div className="trust-row">
      <div className="trust-heading">
        <strong>{label}</strong>
        <span>{totalLabel}</span>
      </div>
      <div className="trust-track" aria-label={trackLabel}>
        <span
          className="trust-segment implementation-complete"
          style={{ width: `${implementedWidth}%` }}
          aria-label={`${implementedLabel}: ${implemented}`}
        />
        {remaining > 0 && (
          <span
            className="trust-segment implementation-open"
            style={{ width: `${remainingWidth}%` }}
            aria-label={`${remainingLabel}: ${remaining}`}
          />
        )}
      </div>
      <div className="trust-legend">
        <span>
          <i className="legend-dot implementation-complete" aria-hidden="true" />
          {implementedLabel} {formatNumber(implemented)} ({formatPercent(implemented, total, 0)})
        </span>
        <span>
          <i className="legend-dot implementation-open" aria-hidden="true" />
          {remainingLabel} {formatNumber(remaining)} ({formatPercent(remaining, total, 0)})
        </span>
      </div>
    </div>
  );
}
