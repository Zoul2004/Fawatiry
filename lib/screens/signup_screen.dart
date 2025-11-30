import 'package:flutter/material.dart';
import '../models/user_model.dart';
// import 'signin_screen.dart'; // لتوجيه المستخدم بعد التسجيل

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  // المتغيرات لتخزين مدخلات المستخدم
  String? _personalName, _username, _email, _password, _confirmPassword;
  String? _company, _jobTitle, _phoneNumber;

  // منطق التسجيل
  void _submitSignUp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 1. التحقق من تطابق كلمة السر
      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('كلمة السر وتأكيدها غير متطابقين.')),
        );
        return;
      }

      // 2. منطق التحقق من تكرار اسم المستخدم والبريد (يتم في خدمة AuthService)
      // إذا كان اسم المستخدم غير متكرر:

      // 3. إنشاء المستخدم والبدء بعملية التحقق من البريد
      // AuthService.registerUser(email: _email!, password: _password!, userData: {...});

      // إخطار المستخدم بضرورة تفعيل الحساب
      _showActivationMessage();

      // التوجيه لشاشة تسجيل الدخول
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen()));
    }
  }

  void _showActivationMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ تم التسجيل بنجاح'),
        content: const Text(
          'تم إرسال رابط تفعيل إلى بريدك الإلكتروني. يرجى تفعيل الحساب قبل تسجيل الدخول.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  // ويدجت مُساعد لحقول الإدخال
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String?) onSave,
    String? Function(String?)? validator,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: validator ??
            (value) {
              // التحقق الافتراضي للحقول المطلوبة
              if (value == null || value.isEmpty) {
                return '⚠️ هذا الحقل مطلوب.';
              }
              return null;
            },
        onSaved: onSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل حساب جديد')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('أدخل بياناتك لإنشاء حساب',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(height: 30),

                // 1. الاسم الشخصي (مطلوب)
                _buildTextField(
                  label: 'الاسم الشخصي',
                  icon: Icons.person,
                  onSave: (val) => _personalName = val,
                ),

                // 2. اسم المستخدم (مطلوب - معرف مميز)
                _buildTextField(
                  label: 'اسم المستخدم',
                  icon: Icons.person_pin_circle,
                  onSave: (val) => _username = val,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '⚠️ اسم المستخدم مطلوب.';
                    }
                    if (value.contains(' ')) {
                      return '⚠️ لا يمكن أن يحتوي اسم المستخدم على مسافات.';
                    }
                    // هنا يتم إضافة منطق التحقق من تكرار اسم المستخدم
                    return null;
                  },
                ),

                // 3. البريد الإلكتروني (مطلوب - للتحقق)
                _buildTextField(
                  label: 'البريد الإلكتروني',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onSave: (val) => _email = val,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return '⚠️ يرجى إدخال بريد إلكتروني صالح.';
                    }
                    return null;
                  },
                ),

                // 4. كلمة السر (مطلوب)
                _buildTextField(
                  label: 'كلمة السر',
                  icon: Icons.lock,
                  onSave: (val) => _password = val,
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return '⚠️ يجب أن تكون كلمة السر 6 أحرف على الأقل.';
                    }
                    return null;
                  },
                ),

                // 5. تأكيد كلمة السر (مطلوب)
                _buildTextField(
                  label: 'تأكيد كلمة السر',
                  icon: Icons.lock_outline,
                  onSave: (val) => _confirmPassword = val,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '⚠️ يرجى تأكيد كلمة السر.';
                    }
                    if (value != _passwordController.text) {
                      // يتم التحقق مرة أخرى في دالة _submitSignUp لضمان المقارنة بعد حفظ الحالة
                      return '⚠️ كلمة السر غير متطابقة.';
                    }
                    return null;
                  },
                ),

                // 6. رقم الهاتف (اختياري)
                _buildTextField(
                  label: 'رقم الهاتف (اختياري)',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onSave: (val) => _phoneNumber = val,
                  validator: (_) => null, // اختياري
                ),

                // 7. الشركة (اختياري)
                _buildTextField(
                  label: 'الشركة (اختياري)',
                  icon: Icons.business,
                  onSave: (val) => _company = val,
                  validator: (_) => null, // اختياري
                ),

                // 8. الوظيفة (اختياري)
                _buildTextField(
                  label: 'الوظيفة (اختياري)',
                  icon: Icons.work,
                  onSave: (val) => _jobTitle = val,
                  validator: (_) => null, // اختياري
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: _submitSignUp,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  child: const Text('تسجيل الآن', style: TextStyle(fontSize: 18)),
                ),

                TextButton(
                  onPressed: () {
                    // التوجيه إلى شاشة تسجيل الدخول
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
                  },
                  child: const Text('هل لديك حساب بالفعل؟ تسجيل الدخول'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
