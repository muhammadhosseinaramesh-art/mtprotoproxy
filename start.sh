#!/bin/sh
set -e

# می‌سازیم config.py از متغیرهای محیطی
cat > config.py <<EOF
PORT = ${PORT:-443}
USERS = { "${SECRET}" : 100 }
AD_TAG = "${AD_TAG}"
EOF

# اجرای پروکسی
exec python3 mtprotoproxy.py
