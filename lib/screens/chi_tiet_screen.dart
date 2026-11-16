import 'package:flutter/material.dart';

import '../models/do_uong.dart';

/// Màn 2: Chi tiết đồ uống. Nhận dữ liệu qua constructor,
/// trả kết quả (MonTrongGio) về màn trước bằng Navigator.pop.
class ChiTietScreen extends StatefulWidget {
  final DoUong doUong;
  const ChiTietScreen({super.key, required this.doUong});

  @override
  State<ChiTietScreen> createState() => _ChiTietScreenState();
}

class _ChiTietScreenState extends State<ChiTietScreen> {
  String _size = 'M';
  int _soLuong = 1;

  @override
  Widget build(BuildContext context) {
    final d = widget.doUong;
    final mon = MonTrongGio(d, _size, _soLuong);
    return Scaffold(
      appBar: AppBar(title: Text(d.ten)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: d.mau.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(d.icon, size: 72, color: d.mau),
          ),
          const SizedBox(height: 16),
          Text(d.ten, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(d.moTa),
          const SizedBox(height: 20),
          const Text('Chọn size', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              for (final s in MonTrongGio.phuThuSize.keys)
                ButtonSegment(value: s, label: Text('$s  +${vnd(MonTrongGio.phuThuSize[s]!)}')),
            ],
            selected: {_size},
            onSelectionChanged: (v) => setState(() => _size = v.first),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Số lượng', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton.outlined(
                onPressed: _soLuong > 1 ? () => setState(() => _soLuong--) : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text('$_soLuong', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
              ),
              IconButton.outlined(
                onPressed: () => setState(() => _soLuong++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          // Trả dữ liệu về màn trước
          onPressed: () => Navigator.pop(context, mon),
          icon: const Icon(Icons.add_shopping_cart),
          label: Text('Thêm vào giỏ – ${vnd(mon.thanhTien)}'),
        ),
      ),
    );
  }
}
