// lib/screens/new_invoice_screen.dart

import 'package:flutter/material.dart';
import 'package:invoice_app/models/customer_model.dart'; 
import 'package:invoice_app/models/product_model.dart';
import 'package:invoice_app/models/invoice_model.dart'; // نحتاج جميع النماذج هنا

class NewInvoiceScreen extends StatefulWidget {
  const NewInvoiceScreen({super.key});

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  // الحالة (State) الرئيسية للفاتورة
  CustomerModel? _selectedCustomer;
  final List<InvoiceItemModel> _items = [];
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  bool _isDeferred = false;
  DateTime? _dueDate;
  final TextEditingController _notesController = TextEditingController();

  // بيانات وهمية (يجب استبدالها بالجلب من الخدمات)
  final List<CustomerModel> _dummyCustomers = [
    CustomerModel(customerId: 'C001', name: 'شركة النور', phoneNumber: '0912', dateAdded: DateTime.now()),
    CustomerModel(customerId: 'C002', name: 'أحمد محمود', phoneNumber: '0998', dateAdded: DateTime.now()),
  ];
  final List<ProductModel> _dummyProducts = [
    ProductModel(productId: 'P001', name: 'شاشة عرض 27 بوصة', price: 2500.00),
    ProductModel(productId: 'P002', name: 'خدمة صيانة شهرية', price: 500.00),
  ];

  // دالة لحساب الإجمالي الكلي
  double get _totalAmount => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  // ----------------------------------------------------
  // دالة إضافة عنصر جديد للفاتورة
  // ----------------------------------------------------
  void _addItemToInvoice(ProductModel product) {
    setState(() {
      // التحقق مما إذا كان المنتج موجوداً بالفعل في القائمة
      final existingItemIndex = _items.indexWhere((item) => item.productId == product.productId);
      
      if (existingItemIndex != -1) {
        // إذا كان موجوداً: زيادة الكمية بواحد
        final existingItem = _items[existingItemIndex];
        _items[existingItemIndex] = InvoiceItemModel(
          productId: existingItem.productId,
          productName: existingItem.productName,
          unitPrice: existingItem.unitPrice,
          quantity: existingItem.quantity + 1,
        );
      } else {
        // إذا كان جديداً: إضافة العنصر بكمية 1
        _items.add(InvoiceItemModel(
          productId: product.productId,
          productName: product.name,
          unitPrice: product.price,
          quantity: 1,
        ));
      }
    });
  }

  // ----------------------------------------------------
  // دالة الحفظ الرئيسية
  // ----------------------------------------------------
  void _saveInvoice() {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار عميل أولاً.')),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة منتجات إلى الفاتورة.')),
      );
      return;
    }
    if (_isDeferred && _dueDate == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تحديد تاريخ الاستحقاق للفواتير الآجلة.')),
      );
      return;
    }

    final newInvoice = InvoiceModel(
      invoiceId: 'INV${DateTime.now().millisecondsSinceEpoch}', // معرف فريد
      customerId: _selectedCustomer!.customerId,
      customerName: _selectedCustomer!.name,
      issueDate: DateTime.now(),
      items: _items,
      paymentMethod: _paymentMethod,
      isDeferred: _isDeferred,
      dueDate: _dueDate,
      notes: _notesController.text,
    );
    
    // **********************************************
    // هنا يتم استدعاء خدمة حفظ الفاتورة (InvoiceService)
    // **********************************************
    print('تم إنشاء فاتورة جديدة: ${newInvoice.invoiceId} بقيمة: ${_totalAmount}');
    // Navigator.of(context).pop(); // العودة بعد الحفظ بنجاح
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء فاتورة جديدة'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. تحديد العميل
              _buildCustomerSelector(context),
              const SizedBox(height: 20),

              // 2. إدارة عناصر الفاتورة
              InvoiceItemsEditor(
                items: _items,
                onUpdate: () => setState(() {}), // لإعادة بناء الواجهة عند التغيير
                dummyProducts: _dummyProducts,
                onAddItem: _addItemToInvoice,
              ),
              const SizedBox(height: 20),
              
              // 3. طريقة الدفع والحالة (آجل/مسدد)
              _buildPaymentDetails(),
              const SizedBox(height: 20),

              // 4. إجمالي الفاتورة
              _buildTotalSection(),
              const SizedBox(height: 30),

              // زر الحفظ
              ElevatedButton.icon(
                onPressed: _saveInvoice,
                icon: const Icon(Icons.send),
                label: const Text('حفظ وإصدار الفاتورة', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // مكونات فرعية:
  
  Widget _buildCustomerSelector(BuildContext context) {
    return DropdownButtonFormField<CustomerModel>(
      decoration: const InputDecoration(
        labelText: 'اختر العميل *',
        border: OutlineInputBorder(),
      ),
      value: _selectedCustomer,
      items: _dummyCustomers.map((CustomerModel customer) {
        return DropdownMenuItem<CustomerModel>(
          value: customer,
          child: Text(customer.name),
        );
      }).toList(),
      onChanged: (CustomerModel? newValue) {
        setState(() {
          _selectedCustomer = newValue;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار عميل.' : null,
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('تفاصيل الدفع:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        // تحديد طريقة الدفع
        DropdownButtonFormField<PaymentMethod>(
          decoration: const InputDecoration(
            labelText: 'طريقة الدفع',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
          value: _paymentMethod,
          items: PaymentMethod.values.map((PaymentMethod method) {
            final label = method.toString().split('.').last;
            return DropdownMenuItem<PaymentMethod>(
              value: method,
              child: Text(_getPaymentMethodLabel(method)),
            );
          }).toList(),
          onChanged: (PaymentMethod? newValue) {
            setState(() {
              _paymentMethod = newValue ?? PaymentMethod.cash;
            });
          },
        ),
        const SizedBox(height: 10),

        // مربع آجل وتاريخ الاستحقاق
        Row(
          children: [
            Checkbox(
              value: _isDeferred,
              onChanged: (bool? newValue) {
                setState(() {
                  _isDeferred = newValue ?? false;
                  if (!_isDeferred) {
                    _dueDate = null;
                  }
                });
              },
            ),
            const Text('الفاتورة آجل (دين)'),
            if (_isDeferred)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(_dueDate == null
                        ? 'تحديد تاريخ الاستحقاق'
                        : 'تاريخ الاستحقاق: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
                    onPressed: () => _selectDueDate(context),
                  ),
                ),
              ),
          ],
        ),
        
        // حقل الملاحظات
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'ملاحظات الفاتورة (اختياري)',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('إجمالي الفاتورة:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(
            '${_totalAmount.toStringAsFixed(2)} SDG',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
          ),
        ],
      ),
    );
  }
  
  String _getPaymentMethodLabel(PaymentMethod method) {
      switch (method) {
        case PaymentMethod.cash: return 'نقداً';
        case PaymentMethod.card: return 'بطاقة مصرفية';
        case PaymentMethod.bankTransfer: return 'تحويل بنكي';
        case PaymentMethod.userDefined: return 'أخرى';
      }
    }
}

// =======================================================
// مكون فرعي: لإدارة عناصر الفاتورة
// =======================================================

class InvoiceItemsEditor extends StatelessWidget {
  final List<InvoiceItemModel> items;
  final VoidCallback onUpdate;
  final List<ProductModel> dummyProducts;
  final Function(ProductModel) onAddItem;

  const InvoiceItemsEditor({
    required this.items,
    required this.onUpdate,
    required this.dummyProducts,
    required this.onAddItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('عناصر الفاتورة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 20),
              label: const Text('إضافة منتج'),
              onPressed: () => _showProductSelectionDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
        
        // عرض قائمة العناصر المضافة
        if (items.isEmpty)
          const Center(child: Text('لم يتم إضافة أي منتجات بعد.', style: TextStyle(color: Colors.grey))),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  // حذف العنصر من القائمة
                  items.removeAt(index);
                  onUpdate();
                },
              ),
              title: Text(item.productName),
              subtitle: Text('السعر: ${item.unitPrice.toStringAsFixed(2)} x الكمية: ${item.quantity}'),
              trailing: Text(
                'الإجمالي: ${item.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => _showEditItemDialog(context, item, index), // لتعديل الكمية والسعر
            );
          },
        ),
      ],
    );
  }

  // مربع حوار لاختيار المنتج للإضافة
  void _showProductSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختيار منتج'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dummyProducts.length,
                itemBuilder: (context, index) {
                  final product = dummyProducts[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('السعر: ${product.price.toStringAsFixed(2)} SDG'),
                    onTap: () {
                      onAddItem(product);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            ],
          ),
        );
      },
    );
  }
  
  // مربع حوار لتعديل الكمية والسعر
  void _showEditItemDialog(BuildContext context, InvoiceItemModel item, int index) {
    final TextEditingController quantityController = TextEditingController(text: item.quantity.toString());
    final TextEditingController priceController = TextEditingController(text: item.unitPrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تعديل: ${item.productName}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'الكمية'),
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'سعر الوحدة'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  final newQuantity = int.tryParse(quantityController.text) ?? item.quantity;
                  final newPrice = double.tryParse(priceController.text) ?? item.unitPrice;
                  
                  if (newQuantity > 0 && newPrice >= 0) {
                    items[index] = InvoiceItemModel(
                      productId: item.productId,
                      productName: item.productName,
                      unitPrice: newPrice,
                      quantity: newQuantity,
                    );
                    onUpdate();
                    Navigator.pop(context);
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الكمية يجب أن تكون أكبر من صفر.')),
                    );
                  }
                },
                child: const Text('حفظ التعديل'),
              ),
            ],
          ),
        );
      },
    );
  }
}
