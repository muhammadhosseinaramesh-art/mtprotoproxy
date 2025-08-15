#!/bin/bash
set -e

# ===== پاکسازی و اعتبارسنجی SECRET =====
CLEAN_SECRET=$(echo "$SECRET" | tr -d '[:space:]')

# چک کردن طول و هگزادسیمال بودن
if [ -z "$CLEAN_SECRET" ] || [ ${#CLEAN_SECRET} -ne 64 ] || [[ ! $CLEAN_SECRET =~ ^[0-9a-fA-F]{64}$ ]]; then
  echo "ERROR: SECRET باید دقیقاً 64 کاراکتر و فقط شامل اعداد 0-9 و حروف a-f باشد."
  exit 1
fi

# ===== اعتبارسنجی AD_TAG =====
if [ -z "$AD_TAG" ]; then
  echo "ERROR: AD_TAG نمی‌تواند خالی باشد."
  exit 1
fi

# ===== متغیرها را صادر کن =====
export SECRET="$CLEAN_SECRET"
export AD_TAG="$AD_TAG"
export PORT="${PORT:-8080}"
export HOST="${HOST:-0.0.0.0}"

echo "Starting MTProto Proxy and HTTP Health Check..."
echo "HOST=$HOST, PORT=$PORT, AD_TAG=$AD_TAG"

# ===== اجرای پروکسی MTProto در پس‌زمینه =====
python3 -u mtprotoproxy.py > proxy.log 2>&1 &
PROXY_PID=$!

# ===== اجرای یک سرور HTTP ساده برای Render Health Check =====
cd /tmp && echo 'OK' > health.html
python3 -m http.server "$PORT" --bind "$HOST" --directory /tmp > health.log 2>&1 &
HEALTH_PID=$!

echo "MTProto Proxy PID: $PROXY_PID"
echo "HTTP Health Check PID: $HEALTH_PID"

# ===== منتظر ماندن تا یکی از فرآیندها متوقف شود =====
wait -n
# اگر یکی متوقف شد، بقیه را هم kill کن
kill $PROXY_PID $HEALTH_PID 2>/dev/null || true
wait $PROXY_PID $HEALTH_PID 2>/dev/null || true
echo "One of the processes has exited."
exit 1
