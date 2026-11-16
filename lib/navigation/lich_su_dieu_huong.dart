import 'package:flutter/material.dart';

/// NavigatorObserver ghi lại ngăn xếp route hiện tại để hiển thị khi demo.
class LichSuDieuHuong extends NavigatorObserver {
  final nganXep = ValueNotifier<List<String>>([]);
  final List<String> _ds = []; // danh sách thật, cập nhật ngay khi có sự kiện

  String _ten(Route<dynamic> r) =>
      r.settings.name ?? (r is PopupRoute ? '(hộp thoại)' : '(không tên)');

  void _capNhat(void Function(List<String> ds) thayDoi) {
    thayDoi(_ds);
    final banSao = List<String>.of(_ds);
    // hiển thị sau frame để không gọi setState trong lúc build
    WidgetsBinding.instance.addPostFrameCallback((_) => nganXep.value = banSao);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _capNhat((ds) => ds.add(_ten(route)));

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _capNhat((ds) => ds.removeLast());

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _capNhat((ds) => ds.remove(_ten(route)));

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _capNhat((ds) {
        final i = oldRoute == null ? -1 : ds.lastIndexOf(_ten(oldRoute));
        if (i >= 0 && newRoute != null) ds[i] = _ten(newRoute);
      });
}

/// Thanh nhỏ ở cuối màn hình hiển thị ngăn xếp: / › /chi-tiet › ...
class ThanhNganXep extends StatelessWidget {
  final LichSuDieuHuong lichSu;
  const ThanhNganXep({super.key, required this.lichSu});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF263238),
      child: SafeArea(
        minimum: EdgeInsets.zero,
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ValueListenableBuilder<List<String>>(
            valueListenable: lichSu.nganXep,
            builder: (context, ds, _) => Text(
              'Ngăn xếp: ${ds.join('  ›  ')}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }
}
