# استفاده از image پایه فلاتر
FROM flutterdocker/flutter:stable

WORKDIR /app

# کپی فایل‌های مورد نیاز برای dependencies
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# کپی بقیه فایل‌های پروژه
COPY . .

# آنالیز کد
RUN flutter analyze

# اجرای تست‌ها
RUN flutter test

# ساخت اپ برای اندروید
RUN flutter build apk --release

# ساخت اپ برای وب (در صورت نیاز)
# RUN flutter build web --release

# ساخت اپ برای iOS (نیاز به macOS)
# RUN flutter build ios --release