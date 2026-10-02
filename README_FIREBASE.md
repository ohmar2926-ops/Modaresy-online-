# ربط Madrasaty Online بـ Firebase

تمت إضافة:
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- تسجيل مدرس/طالب
- حفظ المستخدمين في users
- إنشاء الحصص في classes
- إضافة الطلاب للحصص
- assignments للواجبات
- Firestore Security Rules

## الخطوات على جهازك

ثبّت Firebase CLI ثم:
firebase login

ثم:
dart pub global activate flutterfire_cli

داخل المشروع:
flutter pub get
flutterfire configure

اختر مشروع Firebase والمنصات المطلوبة. الأمر سينشئ `lib/firebase_options.dart` تلقائيًا.

بعدها:
flutter run

## من Firebase Console

فعّل:
Authentication > Sign-in method > Email/Password

ثم أنشئ Cloud Firestore Database.

الوثائق الرسمية:
https://firebase.google.com/docs/flutter/setup
https://firebase.google.com/docs/auth/flutter/start
https://firebase.google.com/docs/firestore
