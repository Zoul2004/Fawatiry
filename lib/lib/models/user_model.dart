// lib/models/user_model.dart

class UserModel {
  final String userId;
  final String personalName; // الاسم الشخصي
  final String username; // معرف مميز لا يتكرر
  final String email; // يتم التحقق منه
  final String passwordHash; // يجب تخزين الـ Hash وليس كلمة السر مباشرة
  final String? companyName; // الشركة (اختياري)
  final String? jobTitle; // الوظيفة (اختياري)
  final String? logoUrl; // شعار الشركة (اختياري - رابط الصورة)
  final String? phoneNumber; // رقم الهاتف (اختياري)
  final String? address; // السكن (للملف الشخصي)

  UserModel({
    required this.userId,
    required this.personalName,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.companyName,
    this.jobTitle,
    this.logoUrl,
    this.phoneNumber,
    this.address,
  });

  // دوال لتحويل البيانات إلى/من الخرائط (JSON/Database) - (يمكن إضافتها لاحقاً)
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'personalName': personalName,
    'username': username,
    'email': email,
    'companyName': companyName,
    'jobTitle': jobTitle,
    // ... باقي الحقول
  };
}
