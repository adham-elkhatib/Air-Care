#!/usr/bin/env bash
set -euo pipefail

# اقرأ القيم من متغيرات البيئة أو من ملف web.env
if [ -f "web.env" ]; then
  # shellcheck disable=SC1091
  source web.env
fi

# تأكد إن المتغيرات موجودة
: "${FIREBASE_API_KEY:?}"
: "${FIREBASE_AUTH_DOMAIN:?}"
: "${FIREBASE_PROJECT_ID:?}"
: "${FIREBASE_STORAGE_BUCKET:?}"
: "${FIREBASE_MESSAGING_SENDER_ID:?}"
: "${FIREBASE_APP_ID:?}"

# انسخ التمبلت لملفات حقيقية
cp web/index.template.html web/index.html
cp web/firebase-messaging-sw.template.js web/firebase-messaging-sw.js

# استبدال الـ Placeholders (Linux)
sed -i "s#__FIREBASE_API_KEY__#${FIREBASE_API_KEY}#g" web/index.html web/firebase-messaging-sw.js
sed -i "s#__FIREBASE_AUTH_DOMAIN__#${FIREBASE_AUTH_DOMAIN}#g" web/index.html web/firebase-messaging-sw.js
sed -i "s#__FIREBASE_PROJECT_ID__#${FIREBASE_PROJECT_ID}#g" web/index.html web/firebase-messaging-sw.js
sed -i "s#__FIREBASE_STORAGE_BUCKET__#${FIREBASE_STORAGE_BUCKET}#g" web/index.html web/firebase-messaging-sw.js
sed -i "s#__FIREBASE_MESSAGING_SENDER_ID__#${FIREBASE_MESSAGING_SENDER_ID}#g" web/index.html web/firebase-messaging-sw.js
sed -i "s#__FIREBASE_APP_ID__#${FIREBASE_APP_ID}#g" web/index.html web/firebase-messaging-sw.js

echo "✅ Injected Firebase config into web/index.html and web/firebase-messaging-sw.js"
