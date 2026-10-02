# 🎓 Madrasaty Online — مدرستي أون لاين

منصة تعليمية متعددة المدرسين والطلاب مبنية بـ Flutter وFirebase.

## المزايا الحالية
- 👨‍🏫 حساب مدرس
- 👨‍🎓 حساب طالب
- 🔐 Firebase Authentication
- ☁️ Cloud Firestore
- 🏫 حصص مرتبطة بالمدرس
- 👥 ربط الطلاب بالحصة
- 📝 بنية للواجبات
- 🔒 Firestore Security Rules
- 👨‍👩‍👦 جاهز لإضافة ولي الأمر لاحقًا

## إعداد المشروع

```bash
flutter pub get
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
flutter run
```

`flutterfire configure` ينشئ `lib/firebase_options.dart` الخاص بمشروع Firebase لديك.

## إعداد Firebase

من Firebase Console:

1. أنشئ مشروعًا جديدًا باسم مناسب.
2. فعّل Authentication.
3. فعّل Email/Password.
4. أنشئ Cloud Firestore.
5. نفّذ قواعد `firestore.rules`.

## بنية البيانات

### users
```text
uid
name
email
role: teacher | student
createdAt
```

### classes
```text
teacherId
title
subject
date
time
studentIds[]
createdAt
```

### assignments
```text
teacherId
classId
title
description
dueDate
createdAt
```

## GitHub

بعد إنشاء Repository:

```bash
git init
git add .
git commit -m "Initial Madrasaty Online Firebase app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/madrasaty-online.git
git push -u origin main
```

> لا ترفع `lib/firebase_options.dart` أو مفاتيح خاصة إلى مستودع عام. ملف `.gitignore` مجهز لمنع ذلك.

## الخطوة التالية

إكمال واجهات:
- إنشاء الحصة
- كود انضمام الطالب
- إدارة الطلاب
- الواجبات
- الاختبارات
- رفع الملفات والفيديو
- الإشعارات
- ولي الأمر
- لوحة الإدارة
