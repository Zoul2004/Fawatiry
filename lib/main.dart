// lib/main.dart

import 'package:flutter/material.dart';

// استيراد جميع شاشاتك الرئيسية
import 'package:invoice_app/screens/login_screen.dart';
import 'package:invoice_app/screens/registration_screen.dart';
import 'package:invoice_app/screens/home_screen.dart';
import 'package:invoice_app/screens/customers_screen.dart';
import 'package:invoice_app/screens/products_screen.dart';
import 'package:invoice_app/screens/invoices_screen.dart';
import 'package:invoice_app/screens/new_invoice_screen.dart';

void main() {
  runApp(const InvoiceApp());
}

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // لإخفاء شريط Debug
      title: 'تطبيق إدارة الفواتير',
      theme: ThemeData(
        // تحديد اللغة الافتراضية للواجهة
        fontFamily: 'Tajawal', // يجب عليك إضافة خطوط عربية لمشروعك
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0.5,
        ),
        // تخصيص الأزرار الرئيسية
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        useMaterial3: true,
      ),
      
      // تعيين الاتجاه الافتراضي للواجهة (من اليمين لليسار)
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      // **********************************************
      // 1. تحديد المسارات (Named Routes)
      // **********************************************
      initialRoute: '/login', // البدء بشاشة تسجيل الدخول

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        
        // مسارات شاشات الإدارة
        '/customers': (context) => const CustomersScreen(),
        '/products': (context) => const ProductsScreen(),
        '/invoices': (context) => const InvoicesScreen(),
        
        // مسار إنشاء الفاتورة الجديدة
        '/new_invoice': (context) => const NewInvoiceScreen(),
        
        // يمكن إضافة مسارات أخرى هنا (مثل /profile, /settings, إلخ)
      },
    );
  }
}

// ----------------------------------------------------
// ملاحظة مهمة: تحديث دوال التنقل
// ----------------------------------------------------
// بعد إضافة Named Routes، يجب تعديل دوال التنقل في الشاشات المختلفة:

// مثال 1: الانتقال من شاشة التسجيل إلى تسجيل الدخول (في registration_screen.dart)
/*
  TextButton(
    onPressed: () {
      // بدلاً من: Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      Navigator.pushReplacementNamed(context, '/login'); 
    },
    child: const Text('لديك حساب بالفعل؟ تسجيل الدخول'),
  ),
*/

// مثال 2: الانتقال بعد تسجيل الدخول إلى الشاشة الرئيسية (في login_screen.dart)
/*
  // في دالة _submitLogin
  if (success) {
    // إزالة جميع الشاشات السابقة والانتقال إلى الشاشة الرئيسية
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/home', 
      (Route<dynamic> route) => false
    );
  }
*/
