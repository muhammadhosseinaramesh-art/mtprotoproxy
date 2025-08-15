# از تصویر رسمی MTProxy استفاده می‌کنیم
FROM alexbers/mtprotoproxy:latest

# متغیر محیطی برای secret
ENV MTSECRET=0123456789abcdef0123456789abcdef
ENV PORT=443

# پورت برای اتصال پروکسی
EXPOSE 443

# اجرای MTProxy
CMD ["./mtproto-proxy", "-u", "0", "-p", "443", "-H", "443", "--aes-pwd", "proxy-secret proxy-multi.conf", "-M", "1"]
