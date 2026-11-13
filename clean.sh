docker system df -v
#!/usr/bin/env bash
# Parsea la salida de `docker system df -v` y muestra cada sección
# (Images, Containers, Local Volumes, Build Cache) ordenada por tamaño real.
#
# Uso:
#   docker system df -v > /tmp/vols.txt
#   ./parse-docker-df.sh /tmp/vols.txt
#
# También puedes ejecutarlo en pipe directamente:
#   docker system df -v | ./parse-docker-df.sh

FILE="${1:-/dev/stdin}"

# Convierte un tamaño humano (751MB, 1.2GB, 500kB, 0B) a bytes
to_bytes() {
    local size="$1"
    local num unit
    num=$(echo "$size" | sed -E 's/([0-9.]+).*/\1/')
    unit=$(echo "$size" | sed -E 's/[0-9.]+//')
    [ -z "$num" ] && { echo 0; return; }
    case "$unit" in
        TB) awk "BEGIN {printf \"%.0f\", $num * 1024 * 1024 * 1024 * 1024}" ;;
        GB) awk "BEGIN {printf \"%.0f\", $num * 1024 * 1024 * 1024}" ;;
        MB) awk "BEGIN {printf \"%.0f\", $num * 1024 * 1024}" ;;
        kB|KB) awk "BEGIN {printf \"%.0f\", $num * 1024}" ;;
        B|"") awk "BEGIN {printf \"%.0f\", $num}" ;;
        *) echo 0 ;;
    esac
}

# Detecta a qué sección pertenece cada línea y la etiqueta,
# guardando la columna que contiene el tamaño (varía según sección)
awk '
/^Images space usage:/       { section="IMAGES"; next }
/^Containers space usage:/   { section="CONTAINERS"; next }
/^Local Volumes space usage:/{ section="VOLUMES"; next }
/^Build cache usage:/        { section="BUILDCACHE"; next }
/^$/                         { next }
/^(REPOSITORY|CONTAINER ID|VOLUME NAME|CACHE ID)/ { next }  # cabeceras
{ print section "\t" $0 }
' "$FILE" > /tmp/_docker_df_tagged.txt

process_section() {
    local name="$1"
    local size_field="$2"   # número de columna donde está el SIZE (1-indexed, tras separar por espacios múltiples)
    echo ""
    echo "=== $name (ordenado por tamaño, mayor a menor) ==="
    grep "^$name"$'\t' /tmp/_docker_df_tagged.txt | sed "s/^$name\t//" | while IFS= read -r line; do
        # Extraer el tamaño: buscamos el primer token que matchee patrón número+unidad
        size=$(echo "$line" | grep -oE '[0-9]+(\.[0-9]+)?(B|kB|KB|MB|GB|TB)' | sed -n "${size_field}p")
        [ -z "$size" ] && size=$(echo "$line" | grep -oE '[0-9]+(\.[0-9]+)?(B|kB|KB|MB|GB|TB)' | head -1)
        bytes=$(to_bytes "$size")
        printf "%015d\t%s\t%s\n" "$bytes" "$size" "$line"
    done | sort -rn | cut -f2- | awk -F'\t' '{printf "%-10s %s\n", $1, $2}'
}

process_section "IMAGES" 1
process_section "CONTAINERS" 1
process_section "VOLUMES" 1
process_section "BUILDCACHE" 1

rm -f /tmp/_docker_df_tagged.txt
