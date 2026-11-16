import 'package:flutter/material.dart';

import '../models/do_uong.dart';
import '../navigation/app_routes.dart';

/// Màn 4: Thanh toán. Dùng PopScope để hỏi lại khi người dùng quay lại
/// trong lúc đã nhập thông tin.
class ThanhToanScreen extends StatefulWidget {
  final GioHang gioHang;
  const ThanhToanScreen({super.key, required this.gioHang});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ten = TextEditingController();
  final _sdt = TextEditingController();
  final _diaChi = TextEditingController();
  bool _daNhap = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_ten, _sdt, _diaChi]) {
      c.addListener(() {
        final coDuLieu = _ten.text.isNotEmpty || _sdt.text.isNotEmpty || _diaChi.text.isNotEmpty;
        if (coDuLieu != _daNhap) setState(() => _daNhap = coDuLieu);
      });
    }
  }

  @override
  void dispose() {
    _ten.dispose();
    _sdt.dispose();
    _diaChi.dispose();
    super.dispose();
  }

  Future<bool> _hoiRoiTrang() async {
    final roi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rời khỏi trang?'),
        content: const Text('Thông tin bạn đã nhập sẽ bị mất.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Ở lại')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Rời đi')),
        ],
      ),
    );
    return roi ?? false;
  }

  void _datHang() {
    if (!_formKey.currentState!.validate()) return;
    final g = widget.gioHang;
    final don = DonHang(
      'DH${DateTime.now().millisecondsSinceEpoch % 100000}',
      _ten.text.trim(),
      _sdt.text.trim(),
      g.soMon,
      g.tongTien,
    );
    g.xoaHet();
    // Xóa Giỏ hàng, Thanh toán khỏi ngăn xếp, chỉ giữ Trang chủ bên dưới
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.thanhCong,
      ModalRoute.withName(AppRoutes.trangChu),
      arguments: don,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_daNhap, // chưa nhập gì thì cho quay lại bình thường
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final roi = await _hoiRoiTrang();
        if (roi && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Thanh toán')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('${widget.gioHang.soMon} món – ${vnd(widget.gioHang.tongTien)}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ten,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sdt,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().length < 9) ? 'Số điện thoại không hợp lệ' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _diaChi,
                decoration: const InputDecoration(labelText: 'Địa chỉ nhận hàng', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập địa chỉ' : null,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: _datHang,
            child: const Text('Đặt hàng'),
          ),
        ),
      ),
    );
  }
}
