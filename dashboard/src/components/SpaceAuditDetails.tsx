import { AlertTriangle, Info } from "lucide-react";
import { formatNumber, routeTo } from "../lib";
import type {
  SpaceAudit,
  SpaceAuditAssumptions,
  SpaceAuditFailure,
  SpaceAuditTrait,
  ReviewTrait,
} from "../types";
import MathText from "./MathText";

function formatList(values: string[]): string {
  return values.length > 0 ? values.join(", ") : "None";
}

function certificateState(trait: SpaceAuditTrait): "implemented" | "incomplete" | "missing" | "invalid" {
  if (trait.status === "invalid" || (trait.certificate !== null && !trait.typeValid)) return "invalid";
  if (!trait.certificate) return "missing";
  return trait.status === "implemented" ? "implemented" : "incomplete";
}

function certificateLabel(trait: SpaceAuditTrait): string {
  const state = certificateState(trait);
  if (state === "missing") return "Missing certificate";
  if (state === "invalid") return "Invalid certificate";
  if (state === "incomplete") return "Incomplete certificate";
  return "Certificate valid";
}

function assumptionDetails(assumptions: SpaceAuditAssumptions) {
  return (
    <dl className="space-audit-assumptions">
      <div><dt>Expected</dt><dd>{formatList(assumptions.expected)}</dd></div>
      <div><dt>Declared</dt><dd>{formatList(assumptions.declared)}</dd></div>
      <div><dt>Used</dt><dd>{formatList(assumptions.used)}</dd></div>
    </dl>
  );
}

function failureKey(failure: SpaceAuditFailure, index: number): string {
  return `${failure.code}-${failure.message}-${index}`;
}

function auditStatusLabel(status: "implemented" | "not-implemented" | "invalid"): string {
  if (status === "implemented") return "Implemented";
  if (status === "not-implemented") return "Incomplete";
  return "Invalid";
}

export default function SpaceAuditDetails({
  audit,
  catalogTraits,
}: {
  audit: SpaceAudit;
  catalogTraits: ReviewTrait[];
}) {
  if (!audit.targeted) {
    return (
      <div className="space-audit-details">
        <div className="audit-note" role="note">
          <Info size={17} aria-hidden="true" />
          <div>
            <strong>Outside the current audit scope</strong>
            <span>This π-Base catalog space is not currently targeted by the Lean space audit.</span>
          </div>
        </div>
        {catalogTraits.length > 0 && (
          <details className="trait-details">
            <summary>{formatNumber(catalogTraits.length)} known catalog traits</summary>
            <div className="trait-table-wrap">
              <table>
                <thead>
                  <tr><th>Value</th><th>Property</th><th>Status</th></tr>
                </thead>
                <tbody>
                  {catalogTraits.map((trait) => (
                    <tr key={`${trait.property}-${trait.value}`}>
                      <td className={trait.value ? "trait-yes" : "trait-no"}>{trait.value ? "✓" : "×"}</td>
                      <td>
                        <a href={routeTo("review", { kind: "properties", q: trait.property.replace(/^P0+/, "P") })}>
                          <MathText text={trait.name} inline />
                        </a>
                      </td>
                      <td><span className="table-tag">{trait.status}</span></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </details>
        )}
      </div>
    );
  }

  const direct = audit.traits.filter((trait) => trait.certificate && trait.provenance === "direct").length;
  const derived = audit.traits.filter((trait) => trait.certificate && trait.provenance === "derived").length;
  const missing = audit.traits.filter((trait) => certificateState(trait) === "missing").length;
  const invalid = audit.traits.filter((trait) => certificateState(trait) === "invalid").length;
  const allAssumptions = [audit.presentation.assumptions, ...audit.traits.map((trait) => trait.assumptions)];
  const assumptions = {
    expected: [...new Set(allAssumptions.flatMap((item) => item.expected))],
    declared: [...new Set(allAssumptions.flatMap((item) => item.declared))],
    used: [...new Set(allAssumptions.flatMap((item) => item.used))],
    valid: allAssumptions.every((item) => item.valid),
  };
  const axiomAudits = [audit.presentation.axioms, ...audit.traits.map((trait) => trait.axioms)];
  const axiomSummary = {
    trusted: [...new Set(axiomAudits.flatMap((item) => item.trusted))],
    conditional: [...new Set(axiomAudits.flatMap((item) => item.conditional))],
    forbidden: [...new Set(axiomAudits.flatMap((item) => item.forbidden))],
  };
  const forbidden = [
    ...audit.presentation.axioms.forbidden.map((axiom) => ({ scope: "Presentation", axiom })),
    ...audit.traits.flatMap((trait) => trait.axioms.forbidden.map((axiom) => ({
      scope: trait.propertyId.replace(/^P0+/, "P"),
      axiom,
    }))),
  ];
  const failures = [
    ...audit.failures.map((failure) => ({ scope: "Space", failure })),
    ...audit.presentation.failures.map((failure) => ({ scope: "Presentation", failure })),
    ...audit.traits.flatMap((trait) => trait.failures.map((failure) => ({
      scope: trait.propertyId.replace(/^P0+/, "P"),
      failure,
    }))),
  ].filter(({ failure }) => failure.code !== "forbidden-axiom");

  return (
    <div className="space-audit-details">
      {(audit.status !== "implemented" || failures.length > 0 || forbidden.length > 0) && (
        <div className="audit-warning" role="note">
          <AlertTriangle size={17} aria-hidden="true" />
          <div>
            <strong>{audit.status === "invalid" ? "Space audit invalid" : "Space audit incomplete"}</strong>
            <span>
              {formatNumber(failures.length)} recorded failure{failures.length === 1 ? "" : "s"}; {formatNumber(forbidden.length)} forbidden axiom occurrence{forbidden.length === 1 ? "" : "s"}.
            </span>
          </div>
        </div>
      )}

      <dl className="entry-ledger space-audit-ledger">
        <div><dt>Presentation status</dt><dd>{auditStatusLabel(audit.presentation.status)}</dd></div>
        <div><dt>Presentation type</dt><dd>{audit.presentation.typeValid ? "Valid" : "Invalid"}</dd></div>
        <div><dt>Direct certificates</dt><dd>{formatNumber(direct)}</dd></div>
        <div><dt>Derived certificates</dt><dd>{formatNumber(derived)}</dd></div>
        <div><dt>Missing certificates</dt><dd>{formatNumber(missing)}</dd></div>
        <div><dt>Invalid certificates</dt><dd>{formatNumber(invalid)}</dd></div>
        <div><dt>Trait audits</dt><dd>{formatNumber(audit.traits.length)}</dd></div>
      </dl>

      <div className="space-audit-facts">
        <div>
          <h3>Assumptions</h3>
          <span className={`table-tag audit-result-${assumptions.valid ? "valid" : "invalid"}`}>
            {assumptions.valid ? "Valid" : "Mismatch"}
          </span>
          {assumptionDetails(assumptions)}
        </div>
        <div>
          <h3>Axiom audit</h3>
          <dl className="space-audit-assumptions">
            <div><dt>Trusted</dt><dd>{formatList(axiomSummary.trusted)}</dd></div>
            <div><dt>Conditional</dt><dd>{formatList(axiomSummary.conditional)}</dd></div>
            <div><dt>Forbidden</dt><dd>{formatList(axiomSummary.forbidden)}</dd></div>
          </dl>
        </div>
      </div>

      {(failures.length > 0 || forbidden.length > 0) && (
        <details className="audit-issues" open={audit.status !== "implemented"}>
          <summary>Audit diagnostics</summary>
          <ul>
            {failures.map(({ scope, failure }, index) => (
              <li key={failureKey(failure, index)}>
                <span className="table-tag">{failure.code}</span>
                <strong>{scope}</strong>
                <span>{failure.message}</span>
              </li>
            ))}
            {forbidden.map(({ scope, axiom }) => (
              <li key={`${scope}-${axiom}`}>
                <span className="table-tag">forbidden axiom</span>
                <strong>{scope}</strong>
                <code>{axiom}</code>
              </li>
            ))}
          </ul>
        </details>
      )}

      <details className="trait-details">
        <summary>
          {formatNumber(audit.traits.length)} audited traits · {formatNumber(direct)} direct · {formatNumber(derived)} derived
        </summary>
        <div className="trait-table-wrap">
          <table>
            <thead>
              <tr>
                <th>Value</th>
                <th>Property</th>
                <th>Provenance</th>
                <th>Certificate</th>
              </tr>
            </thead>
            <tbody>
              {audit.traits.map((trait) => {
                const state = certificateState(trait);
                return (
                  <tr key={`${trait.propertyId}-${trait.expected}`}>
                    <td className={trait.expected ? "trait-yes" : "trait-no"}>{trait.expected ? "✓" : "×"}</td>
                    <td>
                      <a href={routeTo("review", { kind: "properties", q: trait.propertyId.replace(/^P0+/, "P") })}>
                        <MathText text={trait.name ?? trait.propertyId} inline />
                      </a>
                      {trait.polarity !== trait.expected && <small>Certificate polarity mismatch</small>}
                    </td>
                    <td><span className="table-tag">{trait.provenance ?? "No certificate"}</span></td>
                    <td>
                      <span className={`table-tag certificate-${state}`}>{certificateLabel(trait)}</span>
                      {trait.certificate && <code>{trait.certificate}</code>}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </details>
    </div>
  );
}
