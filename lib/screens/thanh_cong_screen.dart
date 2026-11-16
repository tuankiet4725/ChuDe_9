import 'package:flutter/material.dart';

import '../models/do_uong.dart';
import '../navigation/app_routes.dart';

/// Màn 5: Đặt hàng thành công. Ngăn xếp lúc này chỉ còn: / › /thanh-cong
class ThanhCongScreen extends StatelessWidget {
  final DonHang donHang;
  const ThanhCongScreen({super.key, required this.donHang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt hàng thành công')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.check_circle, size: 96, color: Colors.green),
            const SizedBox(height: 16),
            Text('Cảm ơn ${donHang.tenKhach}!',
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            _dong('Mã đơn', donHang.ma),
            _dong('Số điện thoại', donHang.soDienThoai),
            _dong('Số món', '${donHang.soMon}'),
            _dong('Tổng tiền', vnd(donHang.tongTien)),
            const Spacer(),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              // Quay về trang chủ (route '/')
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.trangChu)),
              child: const Text('Về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dong(String nhan, String giaTri) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(nhan),
            const Spacer(),
            Text(giaTri, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
