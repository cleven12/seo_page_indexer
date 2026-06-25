#!/bin/bash
# Convenience wrapper for Visit Kili
# Recommended daily:
#   ./run.sh --submit --inspect --resume --history-backend sqlite
#
# With MySQL fallback:
#   ./run.sh --submit --inspect --resume --history-backend mysql \
#            --mysql-database visitkili_indexer --mysql-user indexer
#
# Status:
#   ./run.sh --status
#
# Export failed:
#   ./run.sh --export-failed failed.txt

cd "$(dirname "$0")"

python3 seo_indexer.py \
  --site https://visitkili.com \
  --sitemap https://visitkili.com/sitemap.xml \
  --service-account service_account.json \
  --history-backend sqlite \
  "$@"
