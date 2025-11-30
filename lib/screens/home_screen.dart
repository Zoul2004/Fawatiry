import 'package:flutter/material.dart';
import '../models/invoice_model.dart'; // نحتاج لنموذج الفاتورة ودالة الألوان

// بيانات إحصائية وهمية للعرض
class InvoiceStats {
  final int paidCount = 12; // مسدد
  final double paidAmount = 15500.00;
  final int dueCount = 5; // آجل
  final double dueAmount = 8200.00;
  final int overdueCount = 3; // متأخر
  final double overdueAmount = 4500.00;
}

class HomeScreen extends StatelessWidget {
  final InvoiceStats stats = InvoiceStats();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          // ملف شخصي مختصر (يوجه للملف الشخصي)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // توجيه إلى شاشة الملف الشخصي
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الإحصائيات - عدد الفواتير في صف واحد
            const Text('📊 إحصائيات الفواتير',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildStatsRow(context), // عرض الإحصائيات
            const SizedBox(height: 20),

            // قسم المبالغ في صفين
            const Text('💰 المبالغ الإجمالية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildAmountGrid(context),
            const SizedBox(height: 30),

            // زر إنشاء فاتورة
            _buildActionButton(
              context,
              'إنشاء فاتورة جديدة',
              Icons.add_box,
              () {
                // توجيه لصفحة إنشاء فاتورة
              },
            ),
            const SizedBox(height: 10),

            // زر إنشاء تقرير
            _buildActionButton(
              context,
              'طباعة تقرير',
              Icons.picture_as_pdf,
              () {
                // توجيه لصفحة إنشاء تقرير
              },
            ),
            const SizedBox(height: 30),

            // قائمة الفواتير الأخيرة
            const Text('📄 الفواتير الأخيرة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // هنا ستوضع قائمة ديناميكية بآخر الفواتير...
          ],
        ),
      ),
    );
  }

  // ويدجت لبناء بطاقة الإحصائيات (عدد الفواتير)
  Widget _buildStatsCard(
      BuildContext context, String title, int count, InvoiceStatus status) {
    return Expanded(
      child: Card(
        color: getStatusColor(status).withOpacity(0.1), // لون فاتح للخلفية
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                '$count',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(status)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت لعرض صف إحصائيات عدد الفواتير
  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        _buildStatsCard(context, 'مسددة', stats.paidCount, InvoiceStatus.paid),
        const SizedBox(width: 8),
        _buildStatsCard(context, 'آجلة', stats.dueCount, InvoiceStatus.due),
        const SizedBox(width: 8),
        _buildStatsCard(context, 'متأخرة', stats.overdueCount, InvoiceStatus.overdue),
      ],
    );
  }

  // ويدجت لعرض المبالغ (في شبكة صفين)
  Widget _buildAmountGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // عمودين
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // لتمكين التمرير ضمن SingleChildScrollView
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.5, // لتقليل ارتفاع البطاقة
      children: [
        _buildAmountCard('إجمالي المسدد', stats.paidAmount, InvoiceStatus.paid),
        _buildAmountCard('إجمالي الآجل', stats.dueAmount, InvoiceStatus.due),
        _buildAmountCard(
            'إجمالي المتأخر', stats.overdueAmount, InvoiceStatus.overdue),
      ],
    );
  }

  // ويدجت لبناء بطاقة المبلغ
  Widget _buildAmountCard(String title, double amount, InvoiceStatus status) {
    return Card(
      color: getStatusColor(status).withOpacity(0.1),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${amount.toStringAsFixed(2)} SDG', // استخدام رمز العملة الافتراضي
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: getStatusColor(status)),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت لبناء أزرار الإجراءات
  Widget _buildActionButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
