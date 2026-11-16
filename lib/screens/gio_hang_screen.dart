import 'package:flutter/material.dart';

import '../models/do_uong.dart';
import '../navigation/app_routes.dart';

/// Màn 3: Giỏ hàng. Mở bằng named route, nhận GioHang qua arguments.
class GioHangScreen extends StatelessWidget {
  final GioHang gioHang;
  const GioHangScreen({super.key, required this.gioHang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: ListenableBuilder(
        listenable: gioHang,
        builder: (context, _) {
          if (gioHang.rong) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.remove_shopping_cart_outlined, size: 72, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Giỏ hàng đang trống'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Quay lại chọn món'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: gioHang.mon.length,
            itemBuilder: (context, i) {
              final m = gioHang.mon[i];
              return Card(
                child: ListTile(
                  leading: Icon(m.doUong.icon, color: m.doUong.mau),
                  title: Text('${m.doUong.ten} (size ${m.size})'),
                  subtitle: Text('${m.soLuong} × ${vnd(m.donGia)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(vnd(m.thanhTien), style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        tooltip: 'Xóa',
                        onPressed: () => gioHang.xoa(i),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: gioHang,
        builder: (context, _) => gioHang.rong
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.thanhToan, arguments: gioHang),
                  child: Text('Thanh toán – ${vnd(gioHang.tongTien)}'),
                ),
              ),
      ),
    );
  }
}
