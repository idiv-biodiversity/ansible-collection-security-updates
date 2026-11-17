#!/bin/bash
# {{ ansible_managed }}

set \
  -o errexit \
  -o noglob \
  -o nounset \
  -o pipefail \

metric_file="{{ node_exporter_textfile_dir }}/security-updates.prom"

# -----------------------------------------------------------------------------
# set up tmp
# -----------------------------------------------------------------------------

tmp=$(mktemp -p '{{ node_exporter_textfile_dir }}')
chown '{{ node_exporter_system_user }}' "$tmp"
chgrp '{{ node_exporter_system_group }}' "$tmp"
chmod 0640 "$tmp"

function cleanup {
  rm -f "$tmp"
}

trap 'cleanup' EXIT INT TERM

# -----------------------------------------------------------------------------
# app
# -----------------------------------------------------------------------------

{% if prometheus_packages_with_fixes_exclude is defined and
      prometheus_packages_with_fixes_exclude %}
excludes='{{ prometheus_packages_with_fixes_exclude }}'
{% endif %}

packages=$(
  dnf updateinfo list security ${excludes:+--exclude "$excludes"} |
    awk '$1 ~ /^R[HL]SA/ { sum += 1 } BEGIN { sum = 0 } END { print sum }'
) &&
  cat << EOF > "$tmp" && mv "$tmp" "$metric_file"
# HELP node_packages_with_security_fixes packages with security updates
# TYPE node_packages_with_security_fixes gauge
node_packages_with_security_fixes $packages
EOF
