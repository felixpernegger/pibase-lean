import {
  BarChart3,
  BookOpenCheck,
  FlaskConical,
  Github,
  Globe,
  ListTodo,
  Network,
} from "lucide-react";
import type { ReactNode } from "react";
import type { DashboardData } from "../types";
import { routeTo } from "../lib";

const NAV = [
  { route: "overview", label: "Overview", icon: BarChart3 },
  { route: "frontier", label: "Frontier", icon: ListTodo },
  { route: "implications", label: "Implications", icon: FlaskConical },
  { route: "review", label: "Review", icon: BookOpenCheck },
];

export default function Shell({ data, route, children }: { data: DashboardData; route: string; children: ReactNode }) {
  return (
    <div className="app-shell">
      <header className="topbar">
        <div className="topbar-inner">
          <a className="brand" href={routeTo("overview")} aria-label="pibase-lean overview">
            <span className="brand-mark" aria-hidden="true"><Network size={18} /></span>
            <span>
              <strong>{data.project.name}</strong>
              <small>{data.project.domain}</small>
            </span>
          </a>
          <nav className="primary-nav" aria-label="Dashboard sections">
            {NAV.map(({ route: itemRoute, label, icon: Icon }) => (
              <a
                key={itemRoute}
                href={routeTo(itemRoute)}
                aria-current={route === itemRoute ? "page" : undefined}
              >
                <Icon size={16} aria-hidden="true" />
                <span>{label}</span>
              </a>
            ))}
          </nav>
          <div className="topbar-source">
            <a
              className="icon-link"
              href={data.project.referenceUrl}
              aria-label="Open π-Base"
              data-tooltip="π-Base"
            >
              <Globe size={18} aria-hidden="true" />
            </a>
            <a
              className="icon-link"
              href={data.project.repoUrl}
              aria-label={`Open ${data.project.repositoryLabel} on GitHub`}
              data-tooltip="Felix's repository"
            >
              <Github size={18} aria-hidden="true" />
            </a>
          </div>
        </div>
      </header>
      <main className="main-content">{children}</main>
      <footer className="site-footer">
        <span>Built from <a href={data.project.repoUrl}>Felix's pibase-lean</a> and <a href={data.project.referenceUrl}>π-Base</a></span>
        <span>Generated {new Date(data.source.generatedAt).toLocaleString()}</span>
      </footer>
    </div>
  );
}
