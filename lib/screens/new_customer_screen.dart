// lib/screens/new_customer_screen.dart

import 'package:flutter/material.dart';
import 'package:invoice_app/models/customer_model.dart';

// نفترض وجود خدمة للتعامل مع منطق العملاء وقاعدة البيانات
// import 'package:invoice_app/services/customer_service.dart'; 

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tradeNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // ----------------------------------------------------
  // دالة التحقق من التكرار وعرض التنبيه
  // ----------------------------------------------------
  void _showDuplicateCheckDialog({
    required CustomerModel newCustomer, 
    required CustomerModel existingCustomer,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('⚠️ تنبيه: تطابق بيانات عميل', style: TextStyle(color: Colors.red)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('تم العثور على عميل مشابه في النظام (تطابق الاسم أو الهاتف). يرجى المراجعة:'),
                  const SizedBox(height: 15),
                  // عرض المقارنة
                  _buildComparisonRow('الاسم:', existingCustomer.name, newCustomer.name),
                  _buildComparisonRow('الهاتف:', existingCustomer.phoneNumber, newCustomer.phoneNumber),
                  _buildComparisonRow('تجاري:', existingCustomer.tradeName ?? 'لا يوجد', newCustomer.tradeName ?? 'لا يوجد'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.of(context).pop(), 
              ),
              TextButton(
                child: const Text('تحديث السجل القديم', style: TextStyle(color: Colors.orange)),
                onPressed: () {
                  // **********************************************
                  // 1. إجراء التحديث: تحديث بيانات العميل القديم
                  // **********************************************
                  print('طلب تحديث العميل القديم: ${existingCustomer.customerId}');
                  // customerService.updateCustomer(existingCustomer.customerId, newCustomer);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // إغلاق شاشة الإضافة
                },
              ),
              TextButton(
                child: const Text('حفظ على أي حال', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  // **********************************************
                  // 2. إجراء الحفظ: حفظ العميل الجديد رغم التشابه
                  // **********************************************
                  print('طلب حفظ العميل الجديد رغم التشابه');
                  _performSave(newCustomer, skipCheck: true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // مكون فرعي لعرض صف المقارنة في مربع الحوار
  Widget _buildComparisonRow(String label, String existingValue, String newValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text('الموجود: $existingValue')),
          Expanded(child: Text('الجديد: $newValue')),
        ],
      ),
    );
  }
  
  // ----------------------------------------------------
  // دالة الحفظ الرئيسية
  // ----------------------------------------------------
  void _saveCustomer({bool skipCheck = false}) async {
    if (!_formKey.currentState!.validate()) {
      return; // إيقاف إذا كانت هناك حقول فارغة
    }

    final newCustomer = CustomerModel(
      customerId: UniqueKey().toString(), // معرف مؤقت
      name: _nameController.text.trim(),
      tradeName: _tradeNameController.text.trim().isEmpty ? null : _tradeNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      dateAdded: DateTime.now(),
      // باقي الحقول الإحصائية تبدأ بـ 0.0
    );

    if (skipCheck) {
      _performSave(newCustomer);
      return;
    }

    // **********************************************
    // 1. مرحلة التحقق من التكرار (المحاكاة)
    // **********************************************
    
    // يجب استدعاء خدمة البحث هنا: 
    // final existingCustomer = await customerService.findPotentialDuplicate(newCustomer);
    
    // محاكاة نتيجة البحث:
    CustomerModel? existingCustomer = _checkDuplicateSimulation(newCustomer);


    if (existingCustomer != null) {
      // تم العثور على تطابق محتمل: عرض مربع الحوار
      _showDuplicateCheckDialog(
        newCustomer: newCustomer,
        existingCustomer: existingCustomer,
      );
    } else {
      // لا يوجد تطابق: متابعة الحفظ مباشرة
      _performSave(newCustomer);
    }
  }

  void _performSave(CustomerModel customer, {bool skipCheck = false}) {
    // **********************************************
    // 2. مرحلة التنفيذ (الحفظ الفعلي)
    // **********************************************
    
    print('تم حفظ العميل: ${customer.name}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ العميل ${customer.name} بنجاح!')),
    );
    // customerService.saveCustomer(customer);
    if (!skipCheck) {
      Navigator.of(context).pop(); // العودة إلى شاشة العملاء
    }
  }

  // دالة محاكاة للتحقق من التكرار
  CustomerModel? _checkDuplicateSimulation(CustomerModel newCustomer) {
    // افتراض وجود قائمة عملاء وهمية هنا للبحث فيها
    final dummyExistingCustomers = [
      CustomerModel(customerId: 'X999', name: 'شركة النور للتقنية', tradeName: 'النور تك', phoneNumber: '0912345678', location: 'الرياض', dateAdded: DateTime.now()),
      // عميل آخر باسم مختلف لكن نفس رقم الهاتف
      CustomerModel(customerId: 'Y888', name: 'عميل آجل', tradeName: null, phoneNumber: '0912345678', location: 'الخرطوم', dateAdded: DateTime.now()), 
    ];

    // مثال منطقي: التطابق إذا تطابق الاسم أو رقم الهاتف
    try {
      return dummyExistingCustomers.firstWhere(
        (c) => c.name.trim() == newCustomer.name.trim() || c.phoneNumber.trim() == newCustomer.phoneNumber.trim(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة عميل جديد'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // حقل اسم العميل (إلزامي)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'اسم العميل (شخصي/شركة) *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم العميل.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // حقل الاسم التجاري (اختياري)
                TextFormField(
                  controller: _tradeNameController,
                  decoration: const InputDecoration(labelText: 'الاسم التجاري'),
                ),
                const SizedBox(height: 15),

                // حقل رقم الهاتف (إلزامي)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // حقل الموقع/العنوان (اختياري)
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'الموقع/العنوان'),
                ),
                const SizedBox(height: 30),

                // زر الحفظ
                ElevatedButton.icon(
                  onPressed: () => _saveCustomer(), // يبدأ عملية التحقق والحفظ
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ العميل', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

