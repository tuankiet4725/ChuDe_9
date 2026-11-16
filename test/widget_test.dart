import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demo_dieu_huong/main.dart';

void main() {
  testWidgets('Chi tiết trả dữ liệu về trang chủ khi bấm Thêm vào giỏ', (tester) async {
    await tester.pumpWidget(DemoApp());
    expect(find.text('Menu đồ uống'), findsOneWidget);

    await tester.tap(find.text('Bạc xỉu'));
    await tester.pumpAndSettle();
    expect(find.text('Chọn size'), findsOneWidget);

    await tester.tap(find.textContaining('Thêm vào giỏ'));
    await tester.pumpAndSettle();
    expect(find.text('Menu đồ uống'), findsOneWidget);
    expect(find.textContaining('Đã thêm 1 × Bạc xỉu'), findsOneWidget);
  });

  testWidgets('Quay lại từ chi tiết thì nhận null và báo chưa thêm món', (tester) async {
    await tester.pumpWidget(DemoApp());
    await tester.tap(find.text('Bạc xỉu'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Bạn chưa thêm món nào'), findsOneWidget);
  });

  testWidgets('Thanh toán đã nhập thông tin thì hỏi lại khi quay lại', (tester) async {
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(DemoApp(navigatorKey: nav));
    await tester.tap(find.text('Bạc xỉu'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Thêm vào giỏ'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Giỏ hàng'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Thanh toán –'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Kiệt');
    await tester.pump();
    nav.currentState!.maybePop();
    await tester.pumpAndSettle();
    expect(find.text('Rời khỏi trang?'), findsOneWidget);

    await tester.tap(find.text('Ở lại'));
    await tester.pumpAndSettle();
    expect(find.text('Thanh toán'), findsOneWidget);
  });

  testWidgets('Đặt hàng xong chỉ còn Trang chủ bên dưới màn Thành công', (tester) async {
    await tester.pumpWidget(DemoApp());
    await tester.tap(find.text('Bạc xỉu'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Thêm vào giỏ'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Giỏ hàng'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Thanh toán –'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Mai Tuấn Kiệt');
    await tester.enterText(fields.at(1), '0905123456');
    await tester.enterText(fields.at(2), '54 Nguyễn Lương Bằng');
    await tester.tap(find.text('Đặt hàng'));
    await tester.pumpAndSettle();
    expect(find.text('Cảm ơn Mai Tuấn Kiệt!'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Menu đồ uống'), findsOneWidget);
  });

  testWidgets('Route không tồn tại mở trang 404', (tester) async {
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(DemoApp(navigatorKey: nav));
    nav.currentState!.pushNamed('/khuyen-mai');
    await tester.pumpAndSettle();
    expect(find.text('Route "/khuyen-mai" không tồn tại'), findsOneWidget);
  });
}
