# SEO Page Indexer (Generic)

**External, high-control tool for manual Google Indexing API + Search Console inspection.**

Lives outside the web app to avoid any performance impact on shared hosting. Built from proven xenohuru algorithms (JWT via openssl, sitemap recursion, resume/retry logic).

## Features

- Recursive sitemap.xml + sitemap index parsing (or local file)
- Submit pages **one-by-one** to Google Indexing API (`URL_UPDATED`)
- URL Inspection via Search Console (coverageState, lastCrawlTime, indexingState, etc.)
- Strong resume / retry support
- **Multiple history backends** (critical for "proceed where it ended"):
  - `sqlite` (default, zero extra deps, robust)
  - `json` (simple, backward compatible)
  - `mysql` (team / production fallback)
- Daily quota tracking + auto-stop
- `--status`, `--export-failed`, `--retry-errors`
- 100% generic + lightweight (openssl + requests)

## Quick Start (Visit Kili example)

```bash
cd /home/cleven/Private/visitkili-github/seo_page_indexer

# Put service_account.json here (or use --service-account)

# Full run: index via sitemap + inspect all pages
python seo_indexer.py --submit --inspect

# Safe resume after interruption or daily quota
python seo_indexer.py --resume --submit --inspect

# Only run URL inspections (Search Console)
python seo_indexer.py --inspect-only --limit 50

# Fix previous failures
python seo_indexer.py --retry-errors --submit
```

## Configuration

All via CLI flags (no hard-coded values):

- `--site`         → Base site URL
- `--sitemap`      → Full sitemap URL (defaults to `{site}/sitemap.xml`)
- `--service-account` → Path to service account JSON
- `--results`      → Progress file (default: `seo_indexing_results.json`)
- `--url`          → Single URL
- `--limit`        → Max URLs this run

## Requirements

```bash
pip install requests
```

`openssl` must be available (used for JWT signing — same method as the xenohuru scripts).

## Service Account Setup

1. Create service account in Google Cloud
2. Enable **Web Search Indexing API**
3. Download JSON key
4. Add the service account email as **Owner** in Search Console for the property

## Output

Progress is saved after every URL:

```json
{
  "submitted": [...],
  "inspected": [...],
  "errors": [...],
  "quota_exceeded": [...]
}
```

## History Backends (MySQL Fallback)

The tool supports persistent history so you can always "just proceed where it ended".

```bash
# Best default (sqlite file)
python seo_indexer.py --submit --inspect --resume --history-backend sqlite

# MySQL (for teams or when you want DB history)
python seo_indexer.py --submit --inspect --resume \
  --history-backend mysql \
  --mysql-database indexer \
  --mysql-user indexer_user \
  --mysql-password secret
```

Table created automatically: `indexer_jobs` (url, status, submitted_at, inspected_at, attempts, last_error...).

## Typical Visit Kili Flow (after content import)

1. Use the Django CLI:
   ```bash
   python manage.py import_json_content --dir /path/to/json-batches/ --progress
   ```
2. (Optional) mysqldump + restore to prod.
3. Run indexer from your laptop:
   ```bash
   ./run.sh --submit --inspect --resume --limit 120
   ```
4. Check status anytime:
   ```bash
   ./run.sh --status
   ```

## Full CLI

```
python seo_indexer.py --submit --inspect --resume --history-backend sqlite --limit 100
python seo_indexer.py --status
python seo_indexer.py --export-failed failed.txt
python seo_indexer.py --retry-errors --submit
```

## Requirements

```bash
pip install requests
# Optional
pip install pymysql
```

`openssl` required for JWT (same as xenohuru).

## Service Account

1. Google Cloud → Service Account + JSON key
2. Enable **Indexing API**
3. Add the service account as **Owner** in Google Search Console property

## Why This Design?

- One-by-one + persistent state = bulletproof resume even after days
- Lightweight, no heavy google libs
- Optional MySQL exactly for the history fallback case
- Works perfectly after bulk JSON imports on the Visit Kili site

Created as the official external indexer for Visit Kili v2.
