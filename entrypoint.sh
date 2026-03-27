#!/bin/sh
set -e

# -----------------------------
# CPU thread control
# -----------------------------
CPU_FRACTION=${CPU_FRACTION:-1.0}
THREADS=${THREADS:-$(nproc)}

if [ "$CPU_FRACTION" != "1.0" ]; then
  THREADS=$(awk -v f="$CPU_FRACTION" -v n="$(nproc)" 'BEGIN {printf "%.0f", f*n}')
  [ "$THREADS" -lt 1 ] && THREADS=1
  echo "→ CPU fraction ${CPU_FRACTION} → ${THREADS} threads"
fi

# -----------------------------
# Environment-driven mode
# -----------------------------
if [ $# -eq 0 ]; then
  ALGO=${ALGO:-sha256d}
  POOL=${POOL}
  WALLET=${WALLET}
  WORKER=${WORKER}
  PASSWORD=${PASSWORD:-${PASS:-x}}

  if [ -z "$POOL" ] || [ -z "$WALLET" ]; then
    echo "ERROR: POOL and WALLET must be set"
    exit 1
  fi

  # wallet.worker formatting
  if [ -n "$WORKER" ]; then
    USERNAME="${WALLET}.${WORKER}"
  else
    USERNAME="${WALLET}"
  fi

  echo "→ Mining as ${USERNAME}"
  echo "→ Threads: ${THREADS}"

  exec cpuminer \
    -t "$THREADS" \
    -a "$ALGO" \
    -o "$POOL" \
    -u "$USERNAME" \
    -p "$PASSWORD" \
    $EXTRA_FLAGS

else
  # CLI passthrough mode
  exec cpuminer -t "$THREADS" "$@" $EXTRA_FLAGS
fi
