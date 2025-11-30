// lib/main.dart

import 'package:flutter/material.dart';
// استدعاء الشاشة التي أنشأناها
import 'package:invoice_app/screens/registration_screen.dart'; 

void main() {
  runApp(const InvoiceApp());
}

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الفواتير',
      debugShowCheckedModeBanner: false, // لإزالة شارة الـ Debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // تحديد الاتجاه الافتراضي من اليمين لليسار (RTL)
      home: const Directionality(
        textDirection: TextDirection.rtl, // دعم اللغة العربية
        child: RegistrationScreen(), // شاشة البداية
      ),
    );
  }
}
