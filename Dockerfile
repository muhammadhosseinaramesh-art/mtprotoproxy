# Base Image سبک Python
FROM python:3.11-slim

# پوشه کاری
WORKDIR /app

# نصب ابزارهای لازم برای ساخت و cryptography
RUN apt-get update && \
    apt-get install -y gcc libssl-dev build-essential && \
    pip install --no-cache-dir cryptography && \
    rm -rf /var/lib/apt/lists/*

# کپی سورس پروژه
COPY . /app

# نصب پکیج‌های مورد نیاز در صورت وجود requirements.txt
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# کپی و آماده‌سازی start.sh
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# پورت پیش‌فرض کانتینر
EXPOSE 443

# اجرای start.sh
CMD ["./start.sh"]
