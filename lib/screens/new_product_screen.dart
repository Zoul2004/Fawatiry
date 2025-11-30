// lib/screens/new_product_screen.dart

import 'package:flutter/material.dart';
import 'package:invoice_app/models/product_model.dart';

// نفترض وجود خدمة للتعامل مع منطق المنتجات وقاعدة البيانات
// import 'package:invoice_app/services/product_service.dart'; 

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // ----------------------------------------------------
  // دالة التحقق من التكرار وعرض التنبيه (معدلة للمنتجات)
  // ----------------------------------------------------
  void _showDuplicateCheckDialog({
    required ProductModel newProduct, 
    required ProductModel existingProduct,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('⚠️ تنبيه: تطابق اسم المنتج', style: TextStyle(color: Colors.red)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('تم العثور على منتج يحمل نفس الاسم في النظام. يرجى المراجعة:'),
                  const SizedBox(height: 15),
                  // عرض المقارنة
                  _buildComparisonRow('الاسم:', existingProduct.name, newProduct.name),
                  _buildComparisonRow('السعر:', '${existingProduct.price.toStringAsFixed(2)} SDG', '${newProduct.price.toStringAsFixed(2)} SDG'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.of(context).pop(), 
              ),
              TextButton(
                child: const Text('تحديث السعر الحالي', style: TextStyle(color: Colors.orange)),
                onPressed: () {
                  // **********************************************
                  // 1. إجراء التحديث: تحديث سعر المنتج القديم بالجديد
                  // **********************************************
                  print('طلب تحديث المنتج القديم: ${existingProduct.productId}');
                  // productService.updateProductPrice(existingProduct.productId, newProduct.price);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // إغلاق شاشة الإضافة
                },
              ),
              TextButton(
                child: const Text('حفظ كمنتج جديد', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  // **********************************************
                  // 2. إجراء الحفظ: حفظ المنتج الجديد رغم التشابه
                  // **********************************************
                  print('طلب حفظ المنتج الجديد رغم التشابه');
                  _performSave(newProduct, skipCheck: true);
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
  void _saveProduct({bool skipCheck = false}) async {
    if (!_formKey.currentState!.validate()) {
      return; // إيقاف إذا كانت هناك حقول فارغة
    }

    final newProduct = ProductModel(
      productId: UniqueKey().toString(), // معرف مؤقت
      name: _nameController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0.0,
    );

    if (skipCheck) {
      _performSave(newProduct);
      return;
    }

    // **********************************************
    // 1. مرحلة التحقق من التكرار (المحاكاة)
    // **********************************************
    
    // محاكاة نتيجة البحث:
    ProductModel? existingProduct = _checkDuplicateSimulation(newProduct);


    if (existingProduct != null) {
      // تم العثور على تطابق محتمل: عرض مربع الحوار
      _showDuplicateCheckDialog(
        newProduct: newProduct,
        existingProduct: existingProduct,
      );
    } else {
      // لا يوجد تطابق: متابعة الحفظ مباشرة
      _performSave(newProduct);
    }
  }

  void _performSave(ProductModel product, {bool skipCheck = false}) {
    // **********************************************
    // 2. مرحلة التنفيذ (الحفظ الفعلي)
    // **********************************************
    
    print('تم حفظ المنتج: ${product.name}');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ المنتج ${product.name} بنجاح!')),
    );
    // productService.saveProduct(product);
    if (!skipCheck) {
      Navigator.of(context).pop(); // العودة إلى شاشة المنتجات
    }
  }

  // دالة محاكاة للتحقق من التكرار
  ProductModel? _checkDuplicateSimulation(ProductModel newProduct) {
    // افتراض وجود قائمة منتجات وهمية هنا للبحث فيها
    final dummyExistingProducts = [
      ProductModel(productId: 'P001', name: 'شاشة عرض 27 بوصة', price: 2500.00),
      ProductModel(productId: 'P004', name: 'جهاز حاسوب محمول', price: 15000.00), 
    ];

    // منطق التحقق: تطابق الاسم (بغض النظر عن حالة الأحرف)
    try {
      return dummyExistingProducts.firstWhere(
        (p) => p.name.trim().toLowerCase() == newProduct.name.trim().toLowerCase(),
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
          title: const Text('إضافة منتج جديد'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // حقل اسم المنتج (إلزامي)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'اسم المنتج *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المنتج.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // حقل سعر المنتج (إلزامي)
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'سعر المنتج * (SDG)',
                    hintText: 'مثال: 1500.00',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال سعر المنتج.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'الرجاء إدخال سعر صحيح.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // زر الحفظ
                ElevatedButton.icon(
                  onPressed: () => _saveProduct(), // يبدأ عملية التحقق والحفظ
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ المنتج', style: TextStyle(fontSize: 18)),
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
