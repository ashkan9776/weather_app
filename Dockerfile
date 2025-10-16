# استفاده از image رسمی فلاتر
FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

# کپی فایل‌های پروژه
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .


# ساخت اپ
RUN flutter build apk --release

# کپی خروجی به volume
CMD ["sh", "-c", "cp -r build/app/outputs/flutter-apk/ /output/"]