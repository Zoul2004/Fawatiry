// lib/models/customer_model.dart

class CustomerModel {
  final String customerId; // معرف فريد للعميل
  final String name; // اسم العميل (إلزامي)
  final String? tradeName; // الاسم التجاري (اختياري)
  final String phoneNumber; // رقم الهاتف (إلزامي)
  final String? location; // الموقع/العنوان (اختياري)
  final DateTime dateAdded; // تاريخ إضافة العميل

  // هذه الحقول إحصائية، ويتم تحديثها وحسابها في الـ Backend أو طبقة الخدمات
  final int totalInvoices;
  final double paidAmount; // المبلغ المسدد الإجمالي
  final double dueAmount; // المبلغ الآجل الإجمالي
  final double overdueAmount; // المبلغ المتأخر الإجمالي

  CustomerModel({
    required this.customerId,
    required this.name,
    required this.phoneNumber,
    required this.dateAdded,
    this.tradeName,
    this.location,
    this.totalInvoices = 0,
    this.paidAmount = 0.0,
    this.dueAmount = 0.0,
    this.overdueAmount = 0.0,
  });

  // دوال لإنشاء كائن من الخريطة (مثال للبيانات القادمة من قاعدة البيانات)
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customerId'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      dateAdded: DateTime.parse(json['dateAdded']), // تحويل النص إلى تاريخ
      tradeName: json['tradeName'],
      // ... باقي الحقول
    );
  }
}
