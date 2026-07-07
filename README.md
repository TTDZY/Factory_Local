# Electronic Factory IT Management System

Website quản trị hệ thống CNTT cho đề tài **Hệ thống CNTT cho Nhà máy Sản xuất Điện tử**. Dự án gồm ReactJS frontend, Node.js/Express backend, Microsoft SQL Server database, tài liệu deploy ERP Server, Nginx, PM2, Docker tùy chọn và backup scripts.

## Kiến trúc

- Frontend: ReactJS + Vite + React Router + Chart.js.
- Backend: Node.js + Express.js + JWT + bcrypt + Helmet + CORS + rate limit.
- Database: Microsoft SQL Server, database `ElectronicFactoryIT`.
- Production ERP Server: Ubuntu `192.168.1.151`.
- Database Server: Windows Server 2025 `192.168.1.101`.
- Firewall: pfSense LAN `192.168.1.1`, WAN `192.168.10.128/24`, DMZ `192.168.20.1/24`.

## Tài khoản demo

| Username | Password | Role |
|---|---|---|
| admin | 123456 | Admin IT |
| manager | 123456 | Manager |
| user | 123456 | User |

Mật khẩu trong database được hash bằng bcrypt.

## Chạy local bằng Docker SQL Server

```bash
cd "D:\Hệ thống erp nội bộ\factory-it-system"
docker compose up -d
```

Chờ SQL Server sẵn sàng rồi import:

```bash
docker exec -it factory-it-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Factory@123456" -C -i /database/schema.sql
docker exec -it factory-it-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Factory@123456" -C -i /database/seed.sql
```

Nếu bạn đã import database từ bản cũ và không muốn drop lại dữ liệu demo, chạy migration bảo mật:

```bash
docker exec -it factory-it-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Factory@123456" -C -i /database/migrate-security.sql
```

Kiểm tra dữ liệu:

```bash
docker exec -it factory-it-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U factory_app -P "Factory@123456" -C -d ElectronicFactoryIT -Q "SELECT COUNT(*) AS Employees FROM Employees"
```

## Chạy backend local

```bash
cd backend
copy .env.docker.example .env
npm.cmd install
npm.cmd start
```

Backend Docker local mặc định chạy:

```text
http://localhost:5001/api
```

Health check:

```text
http://localhost:5001/api/health
```

## Chạy frontend local

```bash
cd frontend
echo VITE_API_BASE_URL=http://localhost:5001/api > .env
npm.cmd install
npm.cmd run dev
```

Mở URL mà Vite hiển thị, thường là:

```text
http://localhost:5174
```

## Chạy nhanh trên Windows

Tại thư mục gốc:

```text
start-backend-docker.bat
start-frontend.bat
```

## Build production

Frontend:

```bash
cd frontend
npm install
npm run build
```

Backend:

```bash
cd backend
npm install
NODE_ENV=production node server.js
```

## API chính

Authentication:

- `POST /api/auth/login`
- `POST /api/auth/logout`
- `GET /api/auth/profile`

Dashboard:

- `GET /api/dashboard/summary`
- `GET /api/dashboard/production-chart`
- `GET /api/dashboard/quality-chart`
- `GET /api/dashboard/server-status`
- `GET /api/dashboard/recent-alerts`

CRUD:

- `/api/employees`
- `/api/departments`
- `/api/vlans`
- `/api/servers`
- `/api/network-devices`
- `/api/production-lines`
- `/api/quality-checks`
- `/api/inventory`
- `/api/purchases`
- `/api/scada`
- `/api/security-policies`
- `/api/backup-jobs`
- `/api/alerts`

Mỗi module hỗ trợ `GET`, `GET /:id`, `POST`, `PUT /:id`, `DELETE /:id`. Các route yêu cầu JWT token.

## Phân quyền

- Admin IT: xem và CRUD toàn bộ.
- Manager: xem dashboard, sản xuất, QA/QC, kho, mua hàng, SCADA.
- User: xem thông tin cơ bản.

## Database

Bảng chính:

`Roles`, `Users`, `Departments`, `Employees`, `VLANs`, `Servers`, `NetworkDevices`, `ProductionLines`, `QualityChecks`, `InventoryItems`, `PurchaseOrders`, `ScadaDevices`, `SecurityPolicies`, `BackupJobs`, `Alerts`, `LoginLogs`, `SystemLogs`.

User ứng dụng:

```text
factory_app / Factory@123456
```

Backend production không dùng `sa`.

## Tài liệu đi kèm

- [DEPLOYMENT.md](DEPLOYMENT.md): deploy ERP Server Ubuntu + PM2 + Nginx.
- [SQL_SETUP.md](SQL_SETUP.md): cấu hình SQL Server Windows Server 2025.
- [TESTING.md](TESTING.md): checklist kiểm thử.
- [REPORT_NOTES.md](REPORT_NOTES.md): ghi chú đưa vào báo cáo.
- [scripts/README_BACKUP.md](scripts/README_BACKUP.md): backup/restore database.

## Thứ tự chạy production

1. Tạo database trên Windows Server 2025.
2. Chạy `schema.sql`.
3. Chạy `seed.sql`.
4. Cấu hình backend `.env`.
5. Cài package và chạy backend bằng PM2.
6. Build frontend.
7. Cấu hình Nginx.
8. Kiểm tra truy cập từ Windows Client `192.168.1.150`.
9. Đăng nhập bằng `admin / 123456`.
10. Kiểm tra dashboard và các module.
