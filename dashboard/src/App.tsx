import { AlertTriangle, RefreshCw } from "lucide-react";
import { lazy, Suspense, useEffect, useState } from "react";
import Shell from "./components/Shell";
import { loadDashboard, parseHash, routeTo } from "./lib";
import Overview from "./pages/Overview";
import type { DashboardBundle } from "./types";

const Frontier = lazy(() => import("./pages/Frontier"));
const Implications = lazy(() => import("./pages/Implications"));
const Review = lazy(() => import("./pages/Review"));

const ROUTES = new Set(["overview", "frontier", "implications", "review"]);
const LEGACY_ROUTES = new Set(["explorer", "experiments", "data"]);

export default function App() {
  const [bundle, setBundle] = useState<DashboardBundle | null>(null);
  const [error, setError] = useState("");
  const [location, setLocation] = useState(parseHash);

  useEffect(() => {
    if (!window.location.hash) window.history.replaceState(null, "", routeTo("overview"));
    const onHashChange = () => setLocation(parseHash());
    window.addEventListener("hashchange", onHashChange);
    return () => window.removeEventListener("hashchange", onHashChange);
  }, []);

  useEffect(() => {
    if (!LEGACY_ROUTES.has(location.route)) return;
    const query = location.params.toString();
    window.history.replaceState(null, "", `#/overview${query ? `?${query}` : ""}`);
    setLocation({ route: "overview", params: location.params });
  }, [location]);

  useEffect(() => {
    let active = true;
    loadDashboard()
      .then((next) => { if (active) { setBundle(next); setError(""); } })
      .catch((reason: unknown) => {
        if (active) setError(reason instanceof Error ? reason.message : "Dashboard data could not be loaded");
      });
    return () => { active = false; };
  }, []);

  if (error) {
    return (
      <main className="fatal-state">
        <AlertTriangle size={28} aria-hidden="true" />
        <h1>Dashboard unavailable</h1>
        <p>{error}</p>
        <button type="button" className="button" onClick={() => window.location.reload()}><RefreshCw size={16} /> Reload</button>
      </main>
    );
  }

  if (!bundle) {
    return (
      <main className="app-loading" aria-live="polite">
        <div className="loading-mark" aria-hidden="true" />
        <strong>pibase-lean</strong>
        <span>Loading research data…</span>
      </main>
    );
  }

  const route = ROUTES.has(location.route) ? location.route : "overview";
  let page;
  switch (route) {
    case "frontier": page = <Frontier bundle={bundle} params={location.params} />; break;
    case "implications": page = <Implications bundle={bundle} params={location.params} />; break;
    case "review": page = <Review data={bundle.data} params={location.params} />; break;
    default: page = <Overview bundle={bundle} params={location.params} />;
  }

  return (
    <Shell data={bundle.data} route={route}>
      <Suspense fallback={<div className="route-loading">Loading workspace…</div>}>
        {page}
      </Suspense>
    </Shell>
  );
}
