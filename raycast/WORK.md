# Raycast work config

This file is intentionally gitignored:
- `raycast/Raycast.work.rayconfig`

Create the work-only search, then export it so it can be imported later.

Steps:
1. Open Raycast Settings.
2. Add a new search (Web Search / Quicklinks).
3. URL:
   `https://intranet-search.workers-hub.com/?from=work&q={{query}}`
4. Export Raycast settings:
   Settings > Advanced > Export
5. Save the exported file as `raycast/Raycast.work.rayconfig`.

Import:
- Settings > Advanced > Import, then select `raycast/Raycast.work.rayconfig`.
