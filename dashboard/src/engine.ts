// TypeScript port of the in-browser pi-base deduction engine from
// felixpernegger/pibase-data (site_engine.js), which mirrors that repo's
// deduce.py. Kept function-for-function compatible so the payload produced by
// Felix's build_site.py (data/implications.json) can be replayed here.
//
// Literals: 2*i encodes propIds[i]=true, 2*i+1 encodes propIds[i]=false;
// negation is lit^1. Models are strings over '1'/'0'/'?' aligned with propIds.

export type Clause = number[];
export type Assignment = Array<boolean | null>;

export interface PropagateResult {
  val: Assignment;
  contradiction: boolean;
}

export interface ProofResult extends PropagateResult {
  used: number[];
}

export function makeIndex(clauses: Clause[], propCount: number): number[][] {
  const byProp: number[][] = Array.from({ length: propCount }, () => []);
  clauses.forEach((clause, clauseIndex) => {
    const seen = new Set<number>();
    for (const lit of clause) {
      const prop = lit >> 1;
      if (!seen.has(prop)) {
        seen.add(prop);
        byProp[prop].push(clauseIndex);
      }
    }
  });
  return byProp;
}

// Unit propagation to fixpoint.
export function propagate(
  clauses: Clause[],
  byProp: number[][],
  propCount: number,
  literals: number[],
): PropagateResult {
  const val: Assignment = new Array(propCount).fill(null);
  const queue: number[] = [];
  function assign(lit: number): boolean {
    const prop = lit >> 1;
    const value = (lit & 1) === 0;
    if (val[prop] === null) {
      val[prop] = value;
      queue.push(prop);
      return true;
    }
    return val[prop] === value;
  }
  for (const lit of literals) {
    if (!assign(lit)) return { val, contradiction: true };
  }
  while (queue.length) {
    const prop = queue.shift()!;
    for (const clauseIndex of byProp[prop]) {
      const clause = clauses[clauseIndex];
      let unknown: number | null = null;
      let satisfied = false;
      let twoUnknown = false;
      for (const lit of clause) {
        const value = val[lit >> 1];
        if (value === null) {
          if (unknown !== null) {
            twoUnknown = true;
            break;
          }
          unknown = lit;
        } else if (value === ((lit & 1) === 0)) {
          satisfied = true;
          break;
        }
      }
      if (satisfied || twoUnknown) continue;
      if (unknown === null) return { val, contradiction: true };
      if (!assign(unknown)) return { val, contradiction: true };
    }
  }
  return { val, contradiction: false };
}

// Like propagate, but tracks which clause forced each assignment so a
// contradiction can be explained. `used` lists the clause indices involved.
export function propagateProof(
  clauses: Clause[],
  byProp: number[][],
  propCount: number,
  literals: number[],
): ProofResult {
  const val: Assignment = new Array(propCount).fill(null);
  const reason: number[] = new Array(propCount).fill(-1); // forcing clause; -1 = given
  const queue: number[] = [];
  let conflict: { clause: number; prop: number } | null = null;

  function assign(lit: number, clauseIndex: number): boolean {
    const prop = lit >> 1;
    const value = (lit & 1) === 0;
    if (val[prop] === null) {
      val[prop] = value;
      reason[prop] = clauseIndex;
      queue.push(prop);
      return true;
    }
    if (val[prop] === value) return true;
    conflict = { clause: clauseIndex, prop };
    return false;
  }

  function result(contradiction: boolean): ProofResult {
    const used = new Set<number>();
    if (contradiction && conflict) {
      const stack: number[] = [];
      if (conflict.clause >= 0) {
        used.add(conflict.clause);
        for (const lit of clauses[conflict.clause]) stack.push(lit >> 1);
      }
      if (conflict.prop >= 0) stack.push(conflict.prop);
      const seen = new Set<number>();
      while (stack.length) {
        const prop = stack.pop()!;
        if (seen.has(prop)) continue;
        seen.add(prop);
        const forcing = reason[prop];
        if (forcing >= 0) {
          used.add(forcing);
          for (const lit of clauses[forcing]) stack.push(lit >> 1);
        }
      }
    }
    return { val, contradiction, used: [...used] };
  }

  for (const lit of literals) {
    if (!assign(lit, -1)) return result(true);
  }
  while (queue.length) {
    const prop = queue.shift()!;
    for (const clauseIndex of byProp[prop]) {
      const clause = clauses[clauseIndex];
      let unknown: number | null = null;
      let satisfied = false;
      let twoUnknown = false;
      for (const lit of clause) {
        const value = val[lit >> 1];
        if (value === null) {
          if (unknown !== null) {
            twoUnknown = true;
            break;
          }
          unknown = lit;
        } else if (value === ((lit & 1) === 0)) {
          satisfied = true;
          break;
        }
      }
      if (satisfied || twoUnknown) continue;
      if (unknown === null) {
        conflict = { clause: clauseIndex, prop: -1 };
        return result(true);
      }
      if (!assign(unknown, clauseIndex)) return result(true);
    }
  }
  return result(false);
}

// Does the literal hold in the model string?
export function holdsIn(model: string, lit: number): boolean {
  return model.charCodeAt(lit >> 1) === ((lit & 1) === 0 ? 49 /* '1' */ : 48 /* '0' */);
}

// Index of the first model where every literal holds, or -1 (counterexample
// check: pass the hypotheses plus the negated conclusion).
export function findModel(models: string[], lits: number[]): number {
  for (let index = 0; index < models.length; index += 1) {
    const model = models[index];
    let all = true;
    for (const lit of lits) {
      if (!holdsIn(model, lit)) {
        all = false;
        break;
      }
    }
    if (all) return index;
  }
  return -1;
}

export function hasModel(models: string[], lits: number[]): boolean {
  return findModel(models, lits) !== -1;
}

export function valToModel(val: Assignment): string {
  let out = "";
  for (const value of val) out += value === null ? "?" : value ? "1" : "0";
  return out;
}

export function modelToLits(model: string): number[] {
  const lits: number[] = [];
  for (let prop = 0; prop < model.length; prop += 1) {
    const code = model.charCodeAt(prop);
    if (code === 49) lits.push(2 * prop); // '1' -> prop true
    else if (code === 48) lits.push(2 * prop + 1); // '0' -> prop false
  }
  return lits;
}

// Re-close every model under an extended clause set (sound: unit-propagation
// closure is a unique fixpoint, so closing an already-closed model under more
// clauses equals closing its original traits under them). Returns null if
// some model becomes contradictory.
export function recloseModels(
  models: string[],
  clauses: Clause[],
  byProp: number[][],
  propCount: number,
): string[] | null {
  const out: string[] = [];
  for (const model of models) {
    const result = propagate(clauses, byProp, propCount, modelToLits(model));
    if (result.contradiction) return null;
    out.push(valToModel(result.val));
  }
  return out;
}

// Canonical statement of a clause (array of literals): the displayed form
// with the fewest negations — conclusion = smallest positive literal if the
// clause has one, else smallest literal; hypotheses = the rest, negated.
export function canonicalStatement(clause: Clause): { hyps: number[]; concl: number } {
  const positives = clause.filter((lit) => !(lit & 1));
  const concl = positives.length ? Math.min(...positives) : Math.min(...clause);
  const hyps = clause
    .filter((lit) => lit !== concl)
    .map((lit) => lit ^ 1)
    .sort((left, right) => left - right);
  return { hyps, concl };
}

// Rejection-sample a random open two-hypothesis statement A ∧ B ⇒ C:
// canonical form, not refuted by a model, not provable, hypotheses
// independent (neither A⇒B nor B⇒A provable), properties from propsOk.
export function drawOpenTriple(
  clauses: Clause[],
  byProp: number[][],
  propCount: number,
  models: string[],
  propsOk: number[],
  maxTries = 2000,
): { hyps: number[]; concl: number } | null {
  for (let attempt = 0; attempt < maxTries; attempt += 1) {
    const picked: number[] = [];
    while (picked.length < 3) {
      const prop = propsOk[Math.floor(Math.random() * propsOk.length)];
      if (!picked.includes(prop)) picked.push(prop);
    }
    const clause = picked.map((prop) => 2 * prop + (Math.random() < 0.5 ? 1 : 0));
    const { hyps, concl } = canonicalStatement(clause);
    const seed = hyps.concat([concl ^ 1]);
    if (hasModel(models, seed)) continue; // refuted
    if (propagate(clauses, byProp, propCount, seed).contradiction) continue; // provable
    const [first, second] = hyps;
    if (propagate(clauses, byProp, propCount, [first, second ^ 1]).contradiction) continue;
    if (propagate(clauses, byProp, propCount, [second, first ^ 1]).contradiction) continue;
    return { hyps, concl };
  }
  return null;
}

// For every open pair, how many open pairs (incl. itself) a true resp. false
// resolution would settle. pairLits: [[aLit, bLit], ...]. ifTrue = -1 marks
// "asserting true would contradict a known space". See site_engine.js for the
// soundness argument behind the incremental re-closures.
export function computeScores(
  clauses: Clause[],
  propCount: number,
  models: string[],
  pairLits: Array<[number, number]>,
): { ifTrue: number[]; ifFalse: number[] } {
  const byProp = makeIndex(clauses, propCount);
  const pairCount = pairLits.length;
  const closures: string[] = new Array(pairCount);
  for (let index = 0; index < pairCount; index += 1) {
    const [a, b] = pairLits[index];
    closures[index] = valToModel(propagate(clauses, byProp, propCount, [a, b ^ 1]).val);
  }

  const ifFalse: number[] = new Array(pairCount).fill(0);
  for (let j = 0; j < pairCount; j += 1) {
    const model = closures[j];
    let count = 0;
    for (let i = 0; i < pairCount; i += 1) {
      const [x, y] = pairLits[i];
      if (holdsIn(model, x) && holdsIn(model, y ^ 1)) count += 1;
    }
    ifFalse[j] = count;
  }

  const ifTrue: number[] = new Array(pairCount).fill(0);
  for (let j = 0; j < pairCount; j += 1) {
    const [hypLit, conclLit] = pairLits[j];
    const clausesJ = clauses.concat([[hypLit ^ 1, conclLit]]);
    const byPropJ = makeIndex(clausesJ, propCount);
    const changed: string[] = [];
    let impossible = false;
    for (const model of models) {
      if (holdsIn(model, hypLit ^ 1) || holdsIn(model, conclLit)) continue; // satisfied
      const hypKnown = model.charCodeAt(hypLit >> 1) !== 63; /* '?' */
      const conclKnown = model.charCodeAt(conclLit >> 1) !== 63;
      if (!hypKnown && !conclKnown) continue; // no unit
      const forced = hypKnown ? conclLit : hypLit ^ 1;
      const result = propagate(clausesJ, byPropJ, propCount, modelToLits(model).concat([forced]));
      if (result.contradiction) {
        impossible = true;
        break;
      }
      changed.push(valToModel(result.val));
    }
    if (impossible) {
      ifTrue[j] = -1;
      continue;
    }

    let score = 0;
    for (let i = 0; i < pairCount; i += 1) {
      const [x, y] = pairLits[i];
      let settled = false;
      for (const model of changed) {
        if (holdsIn(model, x) && holdsIn(model, y ^ 1)) {
          settled = true;
          break;
        }
      }
      if (!settled) {
        const closure = closures[i];
        const hasHyp = holdsIn(closure, hypLit);
        const hasNegConcl = holdsIn(closure, conclLit ^ 1);
        if (hasHyp && hasNegConcl) settled = true;
        else if (hasHyp && closure.charCodeAt(conclLit >> 1) === 63) {
          settled = propagate(clauses, byProp, propCount, modelToLits(closure).concat([conclLit])).contradiction;
        } else if (hasNegConcl && closure.charCodeAt(hypLit >> 1) === 63) {
          settled = propagate(clauses, byProp, propCount, modelToLits(closure).concat([hypLit ^ 1])).contradiction;
        }
      }
      if (settled) score += 1;
    }
    ifTrue[j] = score;
  }
  return { ifTrue, ifFalse };
}
