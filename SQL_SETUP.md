# SQL Server Setup - Windows Server 2025 192.168.1.101

## 1. Bật TCP/IP

1. Mở SQL Server Configuration Manager.
2. Vào `SQL Server Network Configuration`.
3. Chọn instance SQL Server.
4. Bật `TCP/IP`.
5. Trong tab IP Addresses, đặt TCP Port là `1433`.
6. Restart SQL Server service.

## 2. Mở Windows Firewall port 1433

```powershell
New-NetFirewallRule -DisplayName "SQL Server 1433" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
```

## 3. Tạo database

Chạy:

```sql
backend/database/schema.sql
```

Script sẽ tạo database `ElectronicFactoryIT` nếu chưa tồn tại.

## 4. Tạo user database `factory_app`

`schema.sql` đã có:

```sql
CREATE LOGIN factory_app WITH PASSWORD = 'Factory@123456';
CREATE USER factory_app FOR LOGIN factory_app;
ALTER ROLE db_datareader ADD MEMBER factory_app;
ALTER ROLE db_datawriter ADD MEMBER factory_app;
```

Không dùng tài khoản `sa` trong backend production.

## 5. Chạy seed

```sql
backend/database/seed.sql
```

Seed tạo:

- 3 tài khoản demo với mật khẩu bcrypt.
- 120 nhân viên.
- 16 VLAN.
- 5 switch, 3 router, 2 firewall.
- Server ERP, Web, Database, Backup, DNS/DHCP.
- Dữ liệu sản xuất, QA/QC, kho, mua hàng, SCADA, backup, cảnh báo.

## 6. Test từ ERP Server Ubuntu

```bash
/opt/mssql-tools18/bin/sqlcmd -S 192.168.1.101,1433 -U factory_app -P "Factory@123456" -C -d ElectronicFactoryIT -Q "SELECT COUNT(*) AS Employees FROM Employees"
```

## 7. Kiểm tra network

- Database Server: `192.168.1.101`
- ERP Server được phép truy cập SQL Server port `1433`.
- Firewall pfSense cho phép `192.168.1.151 -> 192.168.1.101:1433`.
- Không mở SQL Server trực tiếp ra WAN.
