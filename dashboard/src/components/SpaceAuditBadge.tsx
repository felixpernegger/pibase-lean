import { AlertTriangle, CircleDashed, ShieldCheck, XCircle } from "lucide-react";
import type { SpaceAuditStatus } from "../types";

const LABELS: Record<SpaceAuditStatus, string> = {
  implemented: "Implemented",
  "not-implemented": "Incomplete",
  invalid: "Invalid",
  "not-targeted": "Not targeted",
};

export default function SpaceAuditBadge({ status }: { status: SpaceAuditStatus }) {
  const Icon = status === "implemented"
    ? ShieldCheck
    : status === "invalid"
      ? XCircle
      : status === "not-implemented"
        ? AlertTriangle
        : CircleDashed;

  return (
    <span className={`status-badge space-status-${status}`}>
      <Icon size={14} aria-hidden="true" />
      {LABELS[status]}
    </span>
  );
}
