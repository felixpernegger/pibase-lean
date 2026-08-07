import { ArrowRight, ExternalLink, FileCode2 } from "lucide-react";
import type { MatrixView } from "./Matrix";
import { plainMathLabel } from "../lib";
import type { DashboardData, DirectEdge } from "../types";

function shortTheoremId(id: string): string {
  return id.replace(/^T0+/, "T");
}

function theoremSourceUrl(data: DashboardData, id: string): string {
  const folder = shortTheoremId(id);
  return `${data.project.repoUrl}/blob/${data.source.commit}/PiBaseLean/Theorems/${folder}/Theorem.lean`;
}

export function TheoremLinks({
  data,
  theoremIds,
  view,
}: {
  data: DashboardData;
  theoremIds: string[];
  view: MatrixView;
}) {
  return (
    <div className="evidence-links">
      {theoremIds.map((id) => (
        <a
          key={id}
          href={view === "formalized"
            ? theoremSourceUrl(data, id)
            : `${data.project.referenceUrl}/theorems/${id}`}
        >
          {view === "formalized" ? <FileCode2 size={13} aria-hidden="true" /> : <ExternalLink size={12} aria-hidden="true" />}
          <code>{shortTheoremId(id)}</code>
        </a>
      ))}
    </div>
  );
}

export default function TheoremTrace({
  data,
  path,
  directEdges,
  view,
}: {
  data: DashboardData;
  path: string[];
  directEdges: DirectEdge[];
  view: MatrixView;
}) {
  const propertyMap = new Map(data.properties.map((property) => [property.id, property]));
  const steps = path.slice(0, -1).map((source, index) => {
    const target = path[index + 1];
    const edge = directEdges.find((item) => item.source === source && item.target === target);
    return {
      source: propertyMap.get(source)!,
      target: propertyMap.get(target)!,
      theoremIds: edge?.theorems ?? [],
    };
  });

  return (
    <ol className="proof-trace">
      {steps.map((step) => (
        <li key={`${step.source.id}-${step.target.id}`}>
          <div className="proof-step-pair">
            <code>{step.source.shortId}</code>
            <ArrowRight size={14} aria-hidden="true" />
            <code>{step.target.shortId}</code>
          </div>
          <span className="proof-step-names">{plainMathLabel(step.source.name)} → {plainMathLabel(step.target.name)}</span>
          <TheoremLinks data={data} theoremIds={step.theoremIds} view={view} />
        </li>
      ))}
    </ol>
  );
}
