// نموذج بيانات المستخدم
class User {
  final String userId; // معرف فريد للمستخدم
  String personalName; // الاسم الشخصي
  final String username; // اسم المستخدم (معرف مميز لا يتكرر)
  String email; // البريد الإلكتروني (يتم التحقق منه)
  String? company; // الشركة (اختياري)
  String? jobTitle; // الوظيفة (اختياري)
  String? phoneNumber; // رقم الهاتف (اختياري)
  String? address; // السكن/العنوان (للملف الشخصي)
  String? profileImageUrl; // الصورة الشخصية (اختياري)
  bool isActivated; // حالة تفعيل الحساب (للتحقق من البريد)

  User({
    required this.userId,
    required this.personalName,
    required this.username,
    required this.email,
    this.company,
    this.jobTitle,
    this.phoneNumber,
    this.address,
    this.profileImageUrl,
    this.isActivated = false, // افتراضياً غير مفعّل عند التسجيل
  });

  // دالة تحويل البيانات إلى خريطة (Map) لتخزينها
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'personalName': personalName,
      'username': username,
      'email': email,
      'company': company,
      'jobTitle': jobTitle,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'isActivated': isActivated,
    };
  }
}
  };
}
