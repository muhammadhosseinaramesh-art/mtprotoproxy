FROM python:3.11-slim

WORKDIR /app

# نصب ابزارهای لازم
RUN apt-get update && apt-get install -y --no-install-recommends gcc libssl-dev build-essential && rm -rf /var/lib/apt/lists/*

# کپی سورس به کانتینر
COPY . /app

# اگر requirements.txt باشد نصب کن (در غیر اینصورت نادیده میگیرد)
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# اسکریپتی که قبل از اجرای پروکسی، config.py می‌سازد و سپس پروکسی را اجرا می‌کند
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# پورت کانتینر (برای Render باید پورت کانتینری را 443 تنظیم کنی)
EXPOSE 443

# مقادیر پیش‌فرض (بعداً در Render به‌روزرسانی‌ می‌کنیم)
ENV PORT=443
ENV SECRET=0123456789abcdef0123456789abcdef
ENV AD_TAG=PLACEHOLDER

CMD ["./start.sh"]
