// lib/screens/registration_screen.dart

import 'package:flutter/material.dart';
// لا نحتاج لاستدعاء UserModel هنا الآن، لكن سنحتاجه لاحقاً عند حفظ البيانات.

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // ... إضافة Controllers لباقي الحقول الاختيارية

  void _submitRegistration() {
    // 1. التحقق من صحة الإدخالات في الواجهة
    if (_formKey.currentState!.validate()) {
      // 2. إذا كانت صحيحة، تنفيذ عملية التسجيل
      print('بيانات التسجيل جاهزة للإرسال: ${_nameController.text}');
      
      // هنا يتم إرسال البيانات إلى الـ Backend والتحقق من التكرار
      
      _showSuccessDialog('تم إنشاء الحساب بنجاح. يرجى التحقق من بريدك الإلكتروني لتفعيل الحساب.');
    }
  }
  
  void _showSuccessDialog(String message) {
    // يمكنك استبدال هذا بعرض (Snackbar) أو (AlertDialog) جميل لاحقاً
    print(message); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل حساب جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // حقل الاسم الشخصي (إلزامي)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم الشخصي'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم الشخصي.'; // تنبيه للحقول الفارغة
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // حقل اسم المستخدم (إلزامي - لا يتكرر)
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'اسم المستخدم (معرف مميز)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم مستخدم.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // حقل البريد الإلكتروني (إلزامي - يتم التحقق منه)
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'صيغة البريد الإلكتروني غير صحيحة.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // حقل كلمة السر (إلزامي)
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة السر'),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'يجب أن تكون كلمة السر 6 أحرف على الأقل.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // حقل تأكيد كلمة السر (إلزامي)
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'تأكيد كلمة السر'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة السر.';
                  }
                  if (value != _passwordController.text) {
                    return 'كلمة السر لا تتطابق مع التأكيد.'; // تنبيه التناقض
                  }
                  return null;
                },
              ),
              // ... هنا يمكن إضافة الحقول الاختيارية الأخرى بنفس النمط

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitRegistration,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('تسجيل', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
