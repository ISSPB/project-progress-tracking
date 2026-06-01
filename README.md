# Integrated System — Project Progress Tracking

Static dashboard for contract deliverables, timeline milestones, team roster, and GovTech Knowledge Management (KM) compliance checklist.

## Local preview

Open `index.html` in a browser, or serve the folder:

```bash
cd project-progress-tracking
python3 -m http.server 8080
```

Then visit http://localhost:8080

## GitHub Pages

This repository is configured to deploy the site root to GitHub Pages on every push to `main`.

Live URL (after Pages is enabled): `https://<org-or-user>.github.io/project-progress-tracking/`

Checklist progress is stored in the browser (`localStorage`) per device.
