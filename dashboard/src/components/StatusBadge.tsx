import { AlertTriangle, CheckCircle2, CircleDashed, ShieldCheck } from "lucide-react";
import type { LeanStatusName } from "../types";

const LABELS: Record<LeanStatusName, string> = {
  "dependency-clean": "Dependency-clean",
  "dependency-debt": "Dependency debt",
  "local-debt": "Local proof debt",
  "missing-declaration": "Missing declaration",
};

export default function StatusBadge({ status, label }: { status: LeanStatusName; label?: string }) {
  const Icon = status === "dependency-clean"
    ? ShieldCheck
    : status === "missing-declaration"
      ? CircleDashed
      : status === "local-debt"
        ? AlertTriangle
        : CheckCircle2;
  return (
    <span className={`status-badge status-${status}`}>
      <Icon size={14} aria-hidden="true" />
      {label ?? LABELS[status]}
    </span>
  );
}
