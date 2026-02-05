#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8000/api}"
TOKEN="${TOKEN:-}"   # optional; set for JWT: export TOKEN="eyJ..."

ENDPOINTS=(
  "schools/"
  "users/"
  "klasses/"
  "teachers/"
  "students/"
  "parents/"
  "status/"
  "excuses/"
  "excuseteacher/"
)

auth_header=()
if [[ -n "$TOKEN" ]]; then
  auth_header=(-H "Authorization: Bearer ${TOKEN}")
fi

echo "Base: $BASE_URL"
echo

for ep in "${ENDPOINTS[@]}"; do
  url="${BASE_URL%/}/${ep}"
  echo "==> GET $url"

  # show status + content-type
  curl -sS -o /tmp/api_out.$$ -D - \
    -H "Accept: application/json" \
    "${auth_header[@]}" \
    "$url" \
    | awk 'BEGIN{IGNORECASE=1} /^HTTP\/|^content-type:/{print}' || true

  # if body is JSON, pretty print, else show first lines
  if python -m json.tool < /tmp/api_out.$$ >/tmp/api_json.$$ 2>/dev/null; then
    head -n 40 /tmp/api_json.$$ || true
  else
    head -n 20 /tmp/api_out.$$ || true
  fi

  echo
done

rm -f /tmp/api_out.$$ /tmp/api_json.$$
