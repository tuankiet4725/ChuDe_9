import 'package:flutter/material.dart';

/// Trang 404: hiển thị khi pushNamed tới route không tồn tại (onUnknownRoute).
class KhongTimThayScreen extends StatelessWidget {
  final String tenRoute;
  const KhongTimThayScreen({super.key, required this.tenRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Không tìm thấy trang')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link_off, size: 72, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Route "$tenRoute" không tồn tại', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
