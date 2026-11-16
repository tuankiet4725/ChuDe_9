import 'package:flutter/material.dart';

import '../models/do_uong.dart';
import '../navigation/app_routes.dart';
import 'chi_tiet_screen.dart';

/// Màn 1: Menu đồ uống.
class TrangChuScreen extends StatelessWidget {
  final GioHang gioHang;
  const TrangChuScreen({super.key, required this.gioHang});

  /// push + truyền tham số qua constructor, chờ kết quả trả về khi pop.
  Future<void> _moChiTiet(BuildContext context, DoUong d) async {
    final ketQua = await Navigator.push<MonTrongGio>(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.chiTiet),
        builder: (_) => ChiTietScreen(doUong: d),
      ),
    );
    if (!context.mounted) return;
    final snack = ScaffoldMessenger.of(context);
    snack.hideCurrentSnackBar();
    if (ketQua == null) {
      // người dùng bấm quay lại mà không thêm món
      snack.showSnackBar(const SnackBar(content: Text('Bạn chưa thêm món nào')));
    } else {
      gioHang.them(ketQua);
      snack.showSnackBar(SnackBar(
        content: Text('Đã thêm ${ketQua.soLuong} × ${ketQua.doUong.ten} (size ${ketQua.size})'),
        action: SnackBarAction(
          label: 'XEM GIỎ',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.gioHang, arguments: gioHang),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu đồ uống'),
        actions: [
          ListenableBuilder(
            listenable: gioHang,
            builder: (context, _) => IconButton(
              tooltip: 'Giỏ hàng',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.gioHang, arguments: gioHang),
              icon: Badge(
                isLabelVisible: gioHang.soMon > 0,
                label: Text('${gioHang.soMon}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (route) => Navigator.pushNamed(context, route),
            itemBuilder: (_) => const [
              PopupMenuItem(value: '/khuyen-mai', child: Text('Mở route không tồn tại')),
            ],
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: menu.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final d = menu[i];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: d.mau.withValues(alpha: 0.15),
                child: Icon(d.icon, color: d.mau),
              ),
              title: Text(d.ten, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(d.moTa, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text(vnd(d.gia), style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () => _moChiTiet(context, d),
            ),
          );
        },
      ),
    );
  }
}
