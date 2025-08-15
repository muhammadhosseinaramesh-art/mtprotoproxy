#!/bin/sh
set -e

# می‌سازیم config.py از متغیرهای محیطی
cat > config.py <<EOF
PORT = ${PORT:-443}
USERS = { "${SECRET}" : 100 }
AD_TAG = "${AD_TAG}"
# بقیه تنظیمات پیش‌فرض (در صورت نیاز می‌توانید اضافه کنید)
EOF

# اجرای پروکسی (اسکریپت اصلی در repo alexbers معمولاً mtprotoproxy.py است)
# اگر اسامی در repo شما متفاوت است این خط را اصلاح کن.
exec python3 mtprotoproxy.py
