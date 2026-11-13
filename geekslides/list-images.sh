#!/usr/bin/env bash
set -euo pipefail

project_dir="${1:-.}"
cd "$project_dir"

printf "%-25s %-35s %-20s %-20s %s\n" "SERVICE" "IMAGE" "CONTAINER" "IMAGE_ID" "DIGEST"
printf "%-25s %-35s %-20s %-20s %s\n" "-------" "-----" "---------" "--------" "------"

while IFS= read -r service; do
  image_ref=$(docker compose config 2>/dev/null | awk -v svc="$service" '
    $1=="services:" {in_services=1; next}
    in_services && $1==svc":" {in_svc=1; next}
    in_svc && $1=="image:" {print $2; exit}
    in_svc && /^[^[:space:]]/ {in_svc=0}
  ')

  container_id=$(docker compose ps -q "$service" | head -n1)

  if [[ -z "${container_id:-}" ]]; then
    printf "%-25s %-35s %-20s %-20s %s\n" "$service" "${image_ref:-<unknown>}" "<not running>" "<none>" "<none>"
    continue
  fi

  image_id=$(docker inspect --format '{{.Image}}' "$container_id")
  digest=$(docker inspect --format '{{index .RepoDigests 0}}' "$container_id" 2>/dev/null || true)

  printf "%-25s %-35s %-20s %-20s %s\n" \
    "$service" \
    "${image_ref:-<unknown>}" \
    "${container_id:0:12}" \
    "$image_id" \
    "${digest:-<none>}"
done < <(docker compose config --services)
