# Testing Checklist

## Đăng nhập

- Đăng nhập `admin / 123456` phải vào dashboard.
- Đăng nhập sai mật khẩu phải báo lỗi.
- Gọi login quá nhiều lần phải bị rate limit.

## CRUD nhân viên

- Admin IT xem danh sách nhân viên.
- Admin IT thêm, sửa, xóa nhân viên.
- Manager/User chỉ được xem theo phân quyền.

## CRUD VLAN

- Xem danh sách 16 VLAN.
- Thêm VLAN test, sửa gateway, xóa VLAN test.
- Kiểm tra tìm kiếm theo VLAN ID và dải IP.

## CRUD server

- Kiểm tra Web Server DMZ, ERP Server, Database Server, Backup Server.
- Sửa trạng thái server và xem badge đổi màu.

## Dashboard

- Kiểm tra thẻ thống kê: 120 nhân viên, 16 VLAN, 6 server.
- Kiểm tra biểu đồ sản lượng.
- Kiểm tra biểu đồ QA/QC.
- Kiểm tra trạng thái ERP/DB/Backup/Web/DNS/DHCP/VPN/IDS.

## Kết nối database

```bash
curl http://localhost:5000/api/health
```

Kỳ vọng: `database: connected`.

## Phân quyền

- Admin IT có CRUD đầy đủ.
- Manager xem dashboard, sản xuất, QA/QC, kho, mua hàng, SCADA.
- User xem thông tin cơ bản.
- Route không có token trả `401`.
- Route không đủ role trả `403`.

## Khi SQL Server tắt

- `/api/health` trả `503`.
- Frontend hiển thị lỗi API rõ ràng.

## Khi backend tắt

- Frontend hiển thị lỗi kết nối.
- Nginx `/api` trả 502.

## Giao diện frontend

- Sidebar cố định.
- Header hiển thị tên hệ thống và người dùng.
- Bảng có search/filter, hover, empty state.
- Modal thêm/sửa hiển thị đúng.
- Xóa có confirmation.
- Build production không lỗi: `npm run build`.
