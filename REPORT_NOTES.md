# Report Notes

## 1. Kiến trúc hệ thống

Hệ thống gồm frontend React, backend Node.js Express, database Microsoft SQL Server và hạ tầng mạng nội bộ nhà máy. ERP Server Ubuntu `192.168.1.151` phục vụ ứng dụng web. Database Server Windows Server 2025 `192.168.1.101` lưu dữ liệu nghiệp vụ và hạ tầng.

## 2. Frontend

Frontend dùng ReactJS + Vite, React Router, Chart.js. Giao diện dạng dashboard quản trị nội bộ với sidebar, header, card thống kê, biểu đồ, bảng dữ liệu, badge trạng thái, tìm kiếm, lọc và modal CRUD.

## 3. Backend

Backend dùng Node.js + Express.js, thư viện `mssql` kết nối SQL Server. API có JWT authentication, bcrypt password hash, Helmet, CORS, request logging, rate limit login, middleware role và xử lý lỗi tập trung.

## 4. Database Server

Database `ElectronicFactoryIT` trên Microsoft SQL Server. Các bảng chính gồm Users, Roles, Employees, Departments, VLANs, Servers, NetworkDevices, ProductionLines, QualityChecks, InventoryItems, PurchaseOrders, ScadaDevices, SecurityPolicies, BackupJobs, Alerts, LoginLogs, SystemLogs.

## 5. Triển khai trên ERP Server

ERP Server Ubuntu `192.168.1.151` chạy backend bằng PM2 và frontend build static bằng Nginx. Nginx reverse proxy `/api` về backend nội bộ `127.0.0.1:5000`.

## 6. Windows Server 2025

Windows Server 2025 `192.168.1.101` giữ vai trò AD, DNS, DHCP và Database Server. DNS domain nội bộ là `factory.local`; DHCP cấp scope theo VLAN.

## 7. pfSense Firewall

pfSense có WAN `192.168.10.128/24`, LAN `192.168.1.1/24`, DMZ `192.168.20.1/24`. pfSense kiểm soát ACL, NAT, IDS/IPS, VPN Site-to-Site và Remote Access.

## 8. DMZ

Web Server public đặt trong DMZ tại `192.168.20.10`, cho phép HTTP/HTTPS từ WAN. DMZ bị giới hạn truy cập vào LAN và Database Server.

## 9. VLAN

Hệ thống có 16 VLAN: Management, DMZ, Ban giám đốc, Hành chính, Kế toán, Nhân sự, IT, Sản xuất, QA, QC, SCADA, Kho, Mua hàng, WiFi nội bộ, WiFi khách, Server Farm.

## 10. ACL

ACL giới hạn truy cập giữa VLAN. WiFi khách chỉ đi Internet, SCADA không ra Internet trực tiếp, chỉ VLAN IT quản trị server và thiết bị mạng.

## 11. IDS/IPS

IDS/IPS bật trên pfSense WAN để phát hiện port scan, brute-force, exploit và ghi log về monitoring server.

## 12. Backup

Backup Server `192.168.1.153` lưu bản sao database, ERP, Web và SCADA config. Backup job hiển thị trên giao diện với trạng thái thành công/thất bại/đang chờ.

## 13. VPN

VPN Site-to-Site kết nối trụ sở và nhà máy. VPN Remote Access cho Admin IT và Manager truy cập từ xa an toàn.

## 14. Luồng truy cập

- Người dùng nội bộ truy cập ERP qua LAN đến `192.168.1.151`.
- Người dùng từ xa truy cập qua VPN.
- Website public đặt ở DMZ.
- Database Server chỉ cho ERP Server truy cập port `1433`.

## 15. Lý do chọn SQL Server

SQL Server phù hợp môi trường Windows Server 2025, tích hợp AD, backup/restore tốt, dễ quản trị trong doanh nghiệp sản xuất và đáp ứng dữ liệu nghiệp vụ ERP/QA/QC/kho/mua hàng.
