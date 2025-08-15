#!/bin/bash
set -e

# ===== پاکسازی و اعتبارسنجی SECRET =====
CLEAN_SECRET=$(echo "$SECRET" | tr -d '[:space:]')

# چک کردن طول و هگزادسیمال بودن
if [ -z "$CLEAN_SECRET" ] || [ ${#CLEAN_SECRET} -ne 64 ] || [[ ! $CLEAN_SECRET =~ ^[0-9a-fA-F]{64}$ ]]; then
  echo "ERROR: SECRET باید دقیقاً 64 کاراکتر و فقط شامل اعداد 0-9 و حروف a-f باشد."
  exit 1
fi

# ===== اعتبارسنجی AD_TAG (مثلاً خالی نباشد) =====
if [ -z "$AD_TAG" ]; then
  echo "ERROR: AD_TAG نمی‌تواند خالی باشد."
  exit 1
fi

# ===== متغیرها را صادر کن =====
export SECRET="$CLEAN_SECRET"
export AD_TAG="$AD_TAG"
# مقدار پیش‌فرض 8080 برای تست لوکال، در Render PORT توسط سیستم تعیین می‌شود.
export PORT="${PORT:-8080}"
export HOST="${HOST:-0.0.0.0}"

echo "Starting MTProto Proxy..."
echo "HOST=$HOST, PORT=$PORT, AD_TAG=$AD_TAG"

# ===== اجرای پروکسی =====
exec python3 -u mtprotoproxy.py
