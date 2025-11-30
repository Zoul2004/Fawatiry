// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
// سنفترض وجود شاشة للتسجيل يمكن الانتقال إليها
import 'package:invoice_app/screens/registration_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // دالة محاكاة لتسجيل الدخول
  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      // 1. البيانات المدخلة:
      final identifier = _identifierController.text.trim(); // اسم المستخدم أو البريد
      final password = _passwordController.text;

      print('محاولة تسجيل دخول للمعرف: $identifier');
      
      // 2. هنا يتم استدعاء خدمة المصادقة (AuthService) للتحقق من البيانات
      // (مثلاً، التحقق من كلمة السر المشفرة والمطابقة مع البيانات المخزنة)
      
      // محاكاة لعملية ناجحة:
      if (identifier.isNotEmpty && password.length >= 6) {
        // إذا كان ناجحاً، الانتقال إلى الشاشة الرئيسية
        _showSuccessDialog("تم تسجيل الدخول بنجاح.");
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        // إذا فشل، إظهار رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ في اسم المستخدم/البريد أو كلمة السر.')),
        );
      }
    }
  }

  void _showSuccessDialog(String message) {
    // ... عرض مربع حوار أو طباعة رسالة نجاح
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // حقل اسم المستخدم أو البريد الإلكتروني
              TextFormField(
                controller: _identifierController,
                decoration: const InputDecoration(labelText: 'اسم المستخدم أو البريد الإلكتروني'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المستخدم أو البريد.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // حقل كلمة السر
              TextFormField(
                controller: _passwordController,
                obscureText: true, // لإخفاء النص
                decoration: const InputDecoration(labelText: 'كلمة السر'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة السر.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // زر تسجيل الدخول
              ElevatedButton(
                onPressed: _submitLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
              ),
              
              const SizedBox(height: 20),
              
              // رابط للانتقال إلى شاشة التسجيل
              TextButton(
                onPressed: () {
                  // الانتقال إلى شاشة التسجيل
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                  );
                },
                child: const Text('ليس لديك حساب؟ سجل الآن'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
