# Deployment Guide - ERP Server Ubuntu 192.168.1.151

Triển khai production theo mô hình: frontend React build static, backend Node.js Express chạy bằng PM2, Nginx phục vụ frontend và reverse proxy `/api`.

## 1. Cài Node.js LTS

```bash
sudo apt update
sudo apt install -y curl ca-certificates
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

## 2. Cài Git, Nginx, PM2

```bash
sudo apt install -y git nginx
sudo npm install -g pm2
```

## 3. Copy hoặc clone source

```bash
sudo mkdir -p /opt/factory-it-system
sudo chown -R $USER:$USER /opt/factory-it-system
cd /opt/factory-it-system
```

Copy source project vào thư mục này hoặc clone từ Git nội bộ.

## 4. Cấu hình backend `.env`

```bash
cd /opt/factory-it-system/backend
cp .env.example .env
nano .env
```

Giá trị production:

```env
NODE_ENV=production
PORT=5000
DB_HOST=192.168.1.101
DB_PORT=1433
DB_NAME=ElectronicFactoryIT
DB_USER=factory_app
DB_PASSWORD=Factory@123456
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=true
JWT_SECRET=change-this-long-random-secret
CORS_ORIGIN=http://192.168.1.151
```

## 5. Cài package backend

```bash
cd /opt/factory-it-system/backend
npm install
```

## 6. Test kết nối SQL Server

```bash
node -e "require('dotenv').config(); const sql=require('mssql'); sql.connect({server:process.env.DB_HOST,port:+process.env.DB_PORT,database:process.env.DB_NAME,user:process.env.DB_USER,password:process.env.DB_PASSWORD,options:{encrypt:false,trustServerCertificate:true}}).then(()=>console.log('SQL OK')).catch(e=>{console.error(e.message); process.exit(1)})"
```

## 7. Chạy backend bằng PM2

```bash
cd /opt/factory-it-system/backend
pm2 start ecosystem.config.js
pm2 status
pm2 logs factory-it-backend
```

## 8. PM2 startup sau reboot

```bash
pm2 startup systemd
pm2 save
```

Chạy lệnh `sudo ...` mà PM2 in ra nếu được yêu cầu.

## 9. Build frontend

```bash
cd /opt/factory-it-system/frontend
echo VITE_API_BASE_URL=http://192.168.1.151/api > .env
npm install
npm run build
```

## 10. Copy frontend build cho Nginx

```bash
sudo mkdir -p /var/www/factory-it-system
sudo rsync -av --delete dist/ /var/www/factory-it-system/
sudo chown -R www-data:www-data /var/www/factory-it-system
```

## 11. Cấu hình Nginx

```bash
sudo cp /opt/factory-it-system/nginx/factory-it-system.conf /etc/nginx/sites-available/factory-it-system.conf
sudo ln -sf /etc/nginx/sites-available/factory-it-system.conf /etc/nginx/sites-enabled/factory-it-system.conf
sudo nginx -t
sudo systemctl reload nginx
```

Nginx reverse proxy:

- Frontend: `http://192.168.1.151`
- Backend nội bộ: `http://127.0.0.1:5000`
- API: `http://192.168.1.151/api`
- React Router fallback: `try_files $uri $uri/ /index.html`

## 12. Mở firewall Ubuntu

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp
sudo ufw enable
```

## 13. Kiểm tra từ Windows Client 192.168.1.150

Mở trình duyệt:

```text
http://192.168.1.151
```

## 14. Kiểm tra API health

```bash
curl http://192.168.1.151/api/health
```

Kết quả mong đợi:

```json
{"status":"ok","database":"connected"}
```

## 15. Kiểm tra đăng nhập

Tài khoản demo:

```text
admin / 123456
manager / 123456
user / 123456
```

Sau đăng nhập, kiểm tra dashboard, CRUD nhân viên, VLAN, server, sản xuất, QA/QC, kho, mua hàng, SCADA, bảo mật, backup và cảnh báo.
