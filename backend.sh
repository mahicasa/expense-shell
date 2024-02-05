echo Disable the default version of NodeJS
dnf module disable nodejs -y

echo module enable nodejs18 version
dnf module enable nodejs:18 -y

echo install NodeJS
dnf install nodejs -y

echo configure the backend service
cp backend.service /etc/systemd/system/backend.service

echo creating application useradd
useradd expense

echo remove the existing app content
rm -rf /app

echo create new app directory
mkdir /app

echo download the application content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app

echo extracting application content
unzip /tmp/backend.zip

echo downloading the application dependencies
npm install


echo reloading the SystemD and Start Backend Service
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

echo install the MYSQL server
dnf install mysql -y
mysql -h mysql-dev.mahicasa.online -uroot -pExpenseApp@1 < /app/schema/backend.sql