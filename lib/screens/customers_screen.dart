// lib/screens/customers_screen.dart

import 'package:flutter/material.dart';
import 'package:invoice_app/models/customer_model.dart';
// import 'package:invoice_app/screens/new_customer_screen.dart'; // سنستخدمها لاحقاً

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  // بيانات وهمية للعملاء (يجب استبدالها بجلب البيانات من Services)
  List<CustomerModel> _customers = [
    CustomerModel(customerId: 'C001', name: 'شركة النور للتقنية', tradeName: 'النور تك', phoneNumber: '0912345678', location: 'الرياض', dateAdded: DateTime(2023, 1, 1), totalInvoices: 10, dueAmount: 5000),
    CustomerModel(customerId: 'C002', name: 'أحمد محمود', tradeName: null, phoneNumber: '0998765432', location: 'جدة', dateAdded: DateTime(2023, 5, 15), totalInvoices: 5, paidAmount: 12000),
    CustomerModel(customerId: 'C003', name: 'مؤسسة الريان', tradeName: 'الريان', phoneNumber: '0911223344', location: 'الدمام', dateAdded: DateTime(2024, 2, 20), totalInvoices: 2, overdueAmount: 800),
  ];
  
  String _searchQuery = '';
  List<String> _selectedCustomers = []; // لتنفيذ الحذف المتعدد
  bool _isSelectionMode = false;
  
  // دالة البحث
  List<CustomerModel> get _filteredCustomers {
    if (_searchQuery.isEmpty) {
      return _customers;
    }
    return _customers.where((customer) {
      final query = _searchQuery.toLowerCase();
      return customer.name.toLowerCase().contains(query) ||
             (customer.tradeName ?? '').toLowerCase().contains(query) ||
             customer.phoneNumber.contains(query);
    }).toList();
  }

  // تبديل وضع التحديد للحذف المتعدد
  void _toggleSelectionMode(bool? value) {
    setState(() {
      _is
