import 'package:flutter/material.dart';

import 'models/do_uong.dart';
import 'navigation/app_routes.dart';
import 'navigation/lich_su_dieu_huong.dart';
import 'screens/trang_chu_screen.dart';

/// Demo Chủ đề 9: Điều hướng và quản lý luồng màn hình.
/// Luồng: Menu → Chi tiết → Giỏ hàng → Thanh toán → Đặt hàng thành công.
void main() => runApp(DemoApp());

class DemoApp extends StatefulWidget {
  /// Cho phép điều hướng từ bên ngoài widget tree (ví dụ trong test).
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  DemoApp({super.key, GlobalKey<NavigatorState>? navigatorKey, GlobalKey<ScaffoldMessengerState>? messengerKey})
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        messengerKey = messengerKey ?? GlobalKey<ScaffoldMessengerState>();

  @override
  State<DemoApp> createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  final gioHang = GioHang();
  final lichSu = LichSuDieuHuong();

  @override
  void dispose() {
    gioHang.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo điều hướng',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
      navigatorKey: widget.navigatorKey,
      scaffoldMessengerKey: widget.messengerKey,
      navigatorObservers: [lichSu],
      // Named routes không cần tham số
      initialRoute: AppRoutes.trangChu,
      routes: {
        AppRoutes.trangChu: (_) => TrangChuScreen(gioHang: gioHang),
      },
      // Named routes có tham số (arguments)
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // Route không tồn tại
      onUnknownRoute: AppRoutes.onUnknownRoute,
      // Thanh hiển thị ngăn xếp route ở cuối màn hình (phục vụ demo)
      builder: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child!),
          ThanhNganXep(lichSu: lichSu),
        ],
      ),
    );
  }
}
