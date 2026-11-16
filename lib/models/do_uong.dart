import 'package:flutter/material.dart';

/// Một món đồ uống trong menu.
class DoUong {
  final int id;
  final String ten;
  final String moTa;
  final int gia; // giá size S
  final IconData icon;
  final Color mau;

  const DoUong(this.id, this.ten, this.moTa, this.gia, this.icon, this.mau);
}

/// Một dòng trong giỏ hàng: đồ uống + size + số lượng.
class MonTrongGio {
  final DoUong doUong;
  final String size;
  final int soLuong;

  const MonTrongGio(this.doUong, this.size, this.soLuong);

  static const phuThuSize = {'S': 0, 'M': 5000, 'L': 10000};

  int get donGia => doUong.gia + phuThuSize[size]!;
  int get thanhTien => donGia * soLuong;
}

/// Giỏ hàng dùng chung giữa các màn hình (truyền qua arguments).
class GioHang extends ChangeNotifier {
  final List<MonTrongGio> _mon = [];

  List<MonTrongGio> get mon => List.unmodifiable(_mon);
  int get soMon => _mon.fold(0, (t, m) => t + m.soLuong);
  int get tongTien => _mon.fold(0, (t, m) => t + m.thanhTien);
  bool get rong => _mon.isEmpty;

  void them(MonTrongGio m) {
    _mon.add(m);
    notifyListeners();
  }

  void xoa(int index) {
    _mon.removeAt(index);
    notifyListeners();
  }

  void xoaHet() {
    _mon.clear();
    notifyListeners();
  }
}

/// Thông tin đơn hàng sau khi đặt thành công.
class DonHang {
  final String ma;
  final String tenKhach;
  final String soDienThoai;
  final int soMon;
  final int tongTien;

  const DonHang(this.ma, this.tenKhach, this.soDienThoai, this.soMon, this.tongTien);
}

const menu = [
  DoUong(1, 'Cà phê sữa đá', 'Cà phê phin pha với sữa đặc, uống kèm đá.', 29000, Icons.local_cafe, Color(0xFF795548)),
  DoUong(2, 'Bạc xỉu', 'Nhiều sữa, ít cà phê, vị ngọt dịu.', 32000, Icons.coffee, Color(0xFFA1887F)),
  DoUong(3, 'Trà đào cam sả', 'Trà đen, đào miếng, cam tươi và sả.', 39000, Icons.emoji_food_beverage, Color(0xFFFF8A65)),
  DoUong(4, 'Trà sữa trân châu', 'Trà sữa đậm vị, trân châu đường đen.', 35000, Icons.bubble_chart, Color(0xFF8D6E63)),
  DoUong(5, 'Sinh tố bơ', 'Bơ sáp xay cùng sữa tươi.', 45000, Icons.blender, Color(0xFF7CB342)),
  DoUong(6, 'Nước ép cam', 'Cam vắt nguyên chất, không đường.', 30000, Icons.local_drink, Color(0xFFFFA726)),
];

/// 29000 -> "29.000đ"
String vnd(int so) {
  final s = so.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  buf.write('đ');
  return buf.toString();
}
