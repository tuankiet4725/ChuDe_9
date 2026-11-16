import 'package:flutter/material.dart';

import '../models/do_uong.dart';
import '../screens/gio_hang_screen.dart';
import '../screens/khong_tim_thay_screen.dart';
import '../screens/thanh_cong_screen.dart';
import '../screens/thanh_toan_screen.dart';

/// Tên các route dùng trong ứng dụng (named routes).
class AppRoutes {
  static const trangChu = '/';
  static const chiTiet = '/chi-tiet'; // mở bằng MaterialPageRoute + constructor
  static const gioHang = '/gio-hang';
  static const thanhToan = '/thanh-toan';
  static const thanhCong = '/thanh-cong';

  /// Tạo route theo tên và đọc tham số từ settings.arguments.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case gioHang:
        if (args is GioHang) {
          return MaterialPageRoute(settings: settings, builder: (_) => GioHangScreen(gioHang: args));
        }
      case thanhToan:
        if (args is GioHang) {
          return MaterialPageRoute(settings: settings, builder: (_) => ThanhToanScreen(gioHang: args));
        }
      case thanhCong:
        if (args is DonHang) {
          return MaterialPageRoute(settings: settings, builder: (_) => ThanhCongScreen(donHang: args));
        }
    }
    return null; // sai tên hoặc thiếu tham số -> onUnknownRoute
  }

  /// Route không tồn tại -> trang 404.
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => KhongTimThayScreen(tenRoute: settings.name ?? ''),
    );
  }
}
