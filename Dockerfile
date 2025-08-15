# استفاده از Python سبک
FROM python:3.11-slim

# پوشه کاری داخل کانتینر
WORKDIR /app

# نصب ابزارهای لازم
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libssl-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

# کپی سورس پروژه به کانتینر
COPY . /app

# اگر فایل requirements.txt وجود دارد، پکیج‌ها را نصب کن
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# کپی اسکریپت شروع پروکسی
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# پورت کانتینر (برای Render روی 443)
EXPOSE 443

# تنظیم Environment Variables با کوتیشن
ENV PORT="443"
ENV SECRET="7hYDAQIAAQAB_AMDhuJMOt1tZWRpYS5zdGVhbXBvd2VyZWQuY29t"
ENV AD_TAG="zoroastriann"

# دستور اجرای کانتینر
CMD ["./start.sh"]
