// lib/screens/products_screen.dart

import 'package:flutter/material.dart';
import 'package:invoice_app/models/product_model.dart';
// import 'package:invoice_app/screens/new_product_screen.dart'; // سنستخدمها لاحقاً

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // بيانات وهمية للمنتجات (يجب استبدالها بجلب البيانات من Services)
  List<ProductModel> _products = [
    ProductModel(productId: 'P001', name: 'شاشة عرض 27 بوصة', price: 2500.00),
    ProductModel(productId: 'P002', name: 'خدمة صيانة شهرية', price: 500.00),
    ProductModel(productId: 'P003', name: 'جهاز حاسوب محمول', price: 15000.00),
  ];
  
  String _searchQuery = '';
  List<String> _selectedProducts = []; // لتنفيذ الحذف المتعدد
  bool _isSelectionMode = false;
  
  // دالة البحث
  List<ProductModel> get _filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      final query = _searchQuery.toLowerCase();
      return product.name.toLowerCase().contains(query);
    }).toList();
  }

  // تبديل وضع التحديد للحذف المتعدد
  void _toggleSelectionMode(bool? value) {
    setState(() {
      _isSelectionMode = value ?? !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedProducts.clear();
      }
    });
  }

  // حذف المنتجات المحددة
  void _deleteSelectedProducts() {
    if (_selectedProducts.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إخطار ⚠️'),
        content: Text('هل أنت متأكد من حذف ${_selectedProducts.length} منتج؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              // استدعاء دالة الخدمة للحذف الفعلي
              setState(() {
                _products.removeWhere((p) => _selectedProducts.contains(p.productId));
                _selectedProducts.clear();
                _isSelectionMode = false;
              });
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: _isSelectionMode
              ? Text('${_selectedProducts.length} منتج محدد')
              : const Text('إدارة المنتجات'),
          actions: _isSelectionMode
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: _deleteSelectedProducts,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _toggleSelectionMode(false),
                  ),
                ]
              : [
                  IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: () {
                      // فتح خيارات الترتيب (حسب الاسم/السعر)
                      print('فتح خيارات الترتيب');
                    },
                  ),
                ],
        ),
        body: Column(
          children: <Widget>[
            // شريط البحث
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'بحث عن منتج (بالاسم)',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            
            // قائمة المنتجات
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  final isSelected = _selectedProducts.contains(product.productId);
                  
                  return ProductListItem(
                    product: product,
                    isSelected: isSelected,
                    isSelectionMode: _isSelectionMode,
                    onTap: () {
                      if (_isSelectionMode) {
                        // وضع التحديد مفعل: تحديد/إلغاء تحديد
                        setState(() {
                          if (isSelected) {
                            _selectedProducts.remove(product.productId);
                          } else {
                            _selectedProducts.add(product.productId);
                          }
                          if (_selectedProducts.isEmpty) {
                            _isSelectionMode = false;
                          }
                        });
                      } else {
                        // وضع العرض العادي: فتح شاشة التعديل
                        print('تعديل المنتج: ${product.name}');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(product: product)));
                      }
                    },
                    onLongPress: () {
                      // تفعيل وضع التحديد عند الضغط المطول
                      _toggleSelectionMode(true);
                      setState(() {
                        if (!isSelected) {
                          _selectedProducts.add(product.productId);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
        
        // زر إضافة منتج جديد
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('فتح شاشة إضافة منتج جديد');
            // التوجيه إلى شاشة المنتج الجديد
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewProductScreen()));
          },
          child: const Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }
}

// مكون (Widget) بسيط لعرض عنصر المنتج في القائمة
class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductListItem({
    required this.product,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });
  
  // دالة مساعدة لتنسيق السعر
  String formatCurrency(double price) {
    return '${price.toStringAsFixed(2)} SDG'; 
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: isSelectionMode
          ? Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
            )
          : const Icon(Icons.inventory_2_outlined),
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        formatCurrency(product.price),
        style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold),
      ),
      // إبراز العنصر عند التحديد
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
    );
  }
}
