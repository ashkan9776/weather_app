# استفاده از image پایه فلاتر
FROM flutterdocker/flutter:stable

# دایرکتوری کاری
WORKDIR /app

# کپی فایل‌های پروژه
COPY . .

# گرفتن dependencies
RUN flutter pub get

# ساخت اپ برای پلتفرم مورد نظر
RUN flutter build apk --release