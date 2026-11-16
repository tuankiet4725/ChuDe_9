# Chủ đề 9 – Điều hướng và quản lý luồng màn hình trong Flutter

Ứng dụng demo **đặt đồ uống** gồm 5 màn hình, minh họa điều hướng bằng `Navigator`, truyền dữ liệu giữa các màn hình và xử lý thao tác quay lại.

**Nhóm thực hiện:** Mai Tuấn Kiệt, Bùi Thị Hồng Nguyên
**GVHD:** Nguyễn Duy Nhật Viễn

## Luồng màn hình

```
Menu ──push + constructor──▶ Chi tiết ──pop(context, mon)──▶ Menu
Menu ──pushNamed('/gio-hang', arguments)──▶ Giỏ hàng ──pushNamed('/thanh-toan')──▶ Thanh toán
Thanh toán ──pushNamedAndRemoveUntil('/thanh-cong')──▶ Thành công ──popUntil('/')──▶ Menu
```

| Kỹ thuật | Vị trí trong code |
|---|---|
| `Navigator.push` + truyền dữ liệu qua constructor | `screens/trang_chu_screen.dart` |
| Nhận kết quả: `await push` / `pop(context, value)` | `trang_chu_screen.dart`, `chi_tiet_screen.dart` |
| Named routes, `arguments`, `onGenerateRoute`, `onUnknownRoute` (trang 404) | `navigation/app_routes.dart`, `main.dart` |
| `PopScope` hỏi lại khi rời trang có dữ liệu | `screens/thanh_toan_screen.dart` |
| Xóa lịch sử: `pushNamedAndRemoveUntil`, `popUntil` | `thanh_toan_screen.dart`, `thanh_cong_screen.dart` |
| `NavigatorObserver` hiển thị ngăn xếp route | `navigation/lich_su_dieu_huong.dart` |

## Cấu trúc thư mục

```
lib/
├── main.dart                          # MaterialApp, routes, observer
├── models/do_uong.dart                # DoUong, MonTrongGio, GioHang, DonHang
├── navigation/
│   ├── app_routes.dart                # Tên route, onGenerateRoute, onUnknownRoute
│   └── lich_su_dieu_huong.dart        # NavigatorObserver + thanh ngăn xếp
└── screens/
    ├── trang_chu_screen.dart          # Menu đồ uống
    ├── chi_tiet_screen.dart           # Chi tiết, chọn size và số lượng
    ├── gio_hang_screen.dart           # Giỏ hàng
    ├── thanh_toan_screen.dart         # Thanh toán (PopScope)
    ├── thanh_cong_screen.dart         # Đặt hàng thành công
    └── khong_tim_thay_screen.dart     # Trang 404
test/widget_test.dart                  # 5 widget test cho luồng điều hướng
```

## Chạy ứng dụng

```bash
flutter pub get
flutter run -d chrome      # hoặc: flutter run -d windows (cần Visual Studio)
flutter test
```
