#!/bin/bash
set -e

# ===== پاکسازی و اعتبارسنجی SECRET =====
CLEAN_SECRET=$(echo "$SECRET" | tr -d '[:space:]')

if [ -z "$CLEAN_SECRET" ] || [ ${#CLEAN_SECRET} -ne 64 ]; then
  echo "ERROR: SECRET باید دقیقاً 64 کاراکتر هگزادسیمال باشد"
  exit 1
fi

# ===== اطمینان از رشته بودن AD_TAG =====
AD_TAG=$(echo "$AD_TAG")

# ===== متغیرها را صادر کن =====
export SECRET="$CLEAN_SECRET"
export AD_TAG="$AD_TAG"
export PORT="${PORT:-443}"
export HOST="${HOST:-0.0.0.0}"

echo "Starting MTProto Proxy..."
echo "HOST=$HOST, PORT=$PORT, AD_TAG=$AD_TAG"

# ===== اجرای پروکسی =====
exec python3 -u mtprotoproxy.py
