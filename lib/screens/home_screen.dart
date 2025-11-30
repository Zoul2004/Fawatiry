// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:invoice_app/models/invoice_model.dart'; // نحتاج لـ InvoiceStatus
// نحتاج لاستدعاء باقي الشاشات لاحقاً
// import 'package:invoice_app/screens/profile_screen.dart';
// import 'package:invoice_app/screens/new_invoice_screen.dart'; 
// import 'package:invoice_app/screens/report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: HomeAppBar(), // شريط علوي مخصص للملف الشخصي
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 1. إحصائيات الفواتير والمبالغ
              InvoiceStatisticsSection(),
              SizedBox(height: 20),
              
              // 2. أزرار الإجراءات السريعة
              QuickActionsSection(),
              SizedBox(height: 30),

              // 3. قائمة الفواتير الأخيرة
              Text(
                'آخر الفواتير',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              RecentInvoicesList(), 
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// A. شريط التطبيق العلوي (ملف شخصي مختصر)
// =======================================================

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    // هذه البيانات يجب جلبها من UserModel (المستخدم الحالي)
    const String userName = 'علي أحمد'; 
    const String userInitials = 'ع أ'; 
    
    return AppBar(
      automaticallyImplyLeading: false, // لا يوجد زر رجوع
      title: GestureDetector(
        onTap: () {
          // التوجيه إلى شاشة الملف الشخصي (ProfileScreen)
          print('الضغط على الملف الشخصي -> الانتقال لصفحة الملف الشخصي');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        },
        child: Row(
          children: [
            // صورة أو الأحرف الأولى للمستخدم
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(userInitials, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Text('مرحباً، $userName', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // التوجيه إلى شاشة الإعدادات
            print('فتح الإعدادات');
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          },
        ),
      ],
    );
  }
}

// =======================================================
// B. قسم إحصائيات الفواتير والمبالغ
// =======================================================

class InvoiceStatisticsSection extends StatelessWidget {
  const InvoiceStatisticsSection({super.key});

  // بيانات وهمية للإحصائيات (يجب جلبها من الـ Service Layer)
  static const Map<InvoiceStatus, int> invoiceCounts = {
    InvoiceStatus.paid: 55,
    InvoiceStatus.due: 12,
    InvoiceStatus.overdue: 3,
  };
  
  static const Map<InvoiceStatus, double> invoiceAmounts = {
    InvoiceStatus.paid: 125000.00,
    InvoiceStatus.due: 35000.00,
    InvoiceStatus.overdue: 8000.00,
  };
  
  // دالة مساعدة لتنسيق الأرقام والمبالغ
  String formatCurrency(double amount) {
    // هنا يمكن استخدام دالة تنسيق العملة المحددة في الإعدادات (مثلاً: 125,000.00)
    return '${amount.toStringAsFixed(2)} SDG'; 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إحصائيات الفواتير',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // الصف الأول: عدد الفواتير (مسدد/آجل/متأخر)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: invoiceCounts.entries.map((entry) {
            final color = _getStatusColor(entry.key);
            final label = _getStatusLabel(entry.key);
            return _buildStatCard(
              context,
              count: entry.value,
              label: label,
              color: color,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        
        // الصف الثاني والثالث: إجمالي المبالغ
        _buildAmountRow('المبالغ المسددة:', invoiceAmounts[InvoiceStatus.paid]!, Colors.green),
        _buildAmountRow('المبالغ الآجلة:', invoiceAmounts[InvoiceStatus.due]!, Colors.amber),
        _buildAmountRow('المبالغ المتأخرة:', invoiceAmounts[InvoiceStatus.overdue]!, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, {required int count, required String label, required Color color}) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountRow(String title, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          Text(
            formatCurrency(amount),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid: return Colors.green.shade700;
      case InvoiceStatus.due: return Colors.amber.shade700;
      case InvoiceStatus.overdue: return Colors.red.shade700;
    }
  }
  
  String _getStatusLabel(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid: return 'مسدد';
      case InvoiceStatus.due: return 'آجل';
      case InvoiceStatus.overdue: return 'متأخر';
    }
  }
}

// =======================================================
// C. أزرار الإجراءات السريعة (إنشاء فاتورة/تقرير)
// =======================================================

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // زر إنشاء فاتورة
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              print('الضغط على إنشاء فاتورة');
              // التوجيه إلى شاشة الفاتورة الجديدة (New Invoice Screen)
            },
            icon: const Icon(Icons.add_shopping_cart, size: 20),
            label: const Text('إنشاء فاتورة'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 15),
        // زر إنشاء تقرير
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              print('الضغط على إنشاء تقرير');
              // التوجيه إلى شاشة طباعة التقرير (Report Screen)
            },
            icon: const Icon(Icons.print, size: 20),
            label: const Text('إنشاء تقرير'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}

// =======================================================
// D. قائمة الفواتير الأخيرة (عرض بسيط)
// =======================================================

class RecentInvoicesList extends StatelessWidget {
  const RecentInvoicesList({super.key});

  // بيانات فواتير وهمية (يجب استبدالها ببيانات من الـ Service)
  final List<Map<String, dynamic>> dummyInvoices = const [
    {'id': 'INV005', 'client': 'شركة الأمان', 'amount': 4500.00, 'status': InvoiceStatus.paid},
    {'id': 'INV004', 'client': 'متجر النور', 'amount': 12000.00, 'status': InvoiceStatus.due},
    {'id': 'INV003', 'client': 'فهد خالد', 'amount': 150.00, 'status': InvoiceStatus.overdue},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // يجب إضافة هذه الخصائص لتجنب أخطاء التمدد داخل الـ SingleChildScrollView
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyInvoices.length,
      itemBuilder: (context, index) {
        final invoice = dummyInvoices[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(invoice['status']),
              child: const Icon(Icons.receipt, color: Colors.white, size: 20),
            ),
            title: Text(
              invoice['client'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('رقم: ${invoice['id']}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${invoice['amount'].toStringAsFixed(2)} SDG',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  _getStatusLabel(invoice['status']),
                  style: TextStyle(color: _getStatusColor(invoice['status']), fontSize: 12),
                ),
              ],
            ),
            onTap: () {
              print('الضغط على الفاتورة ${invoice['id']} -> عرض التفاصيل');
              // التوجيه إلى شاشة تفاصيل الفاتورة
            },
          ),
        );
      },
    );
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid: return Colors.green;
      case InvoiceStatus.due: return Colors.amber;
      case InvoiceStatus.overdue: return Colors.red;
    }
  }

  String _getStatusLabel(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid: return 'مسدد';
      case InvoiceStatus.due: return 'آجل';
      case InvoiceStatus.overdue: return 'متأخر';
    }
  }
}
