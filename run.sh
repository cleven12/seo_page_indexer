#!/bin/bash
# Generic convenience wrapper for any site
#
# Usage (edit the values below or override with arguments):
#   ./run.sh --submit --inspect --resume --limit 150
#
# MySQL history backend example:
#   ./run.sh --submit --inspect --resume --history-backend mysql \
#            --mysql-database my_indexer --mysql-user myuser
#
# Other useful commands:
#   ./run.sh --status
#   ./run.sh --export-failed failed.txt
#   ./run.sh --retry-errors --submit

cd "$(dirname "$0")"

python3 seo_indexer.py \
  --site https://example.com \
  --sitemap https://example.com/sitemap.xml \
  --service-account service_account.json \
  --history-backend sqlite \
  "$@"
