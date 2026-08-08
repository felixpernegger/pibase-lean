// Web Worker: leverage scores for the open-implication list. computeScores is
// quadratic in the open list, so it runs off the main thread.
import { computeScores } from "./engine";

export interface ScoreRequest {
  clauses: number[][];
  propCount: number;
  models: string[];
  pairLits: Array<[number, number]>;
}

self.onmessage = (event: MessageEvent<ScoreRequest>) => {
  const { clauses, propCount, models, pairLits } = event.data;
  self.postMessage(computeScores(clauses, propCount, models, pairLits));
};
