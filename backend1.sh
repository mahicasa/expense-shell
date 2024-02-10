MYSQL_PASSWORD=$1
log_file=/tmp/expense.log

echo Disable the default version of NodeJS
dnf module disable nodejs -y &>>$log_file

echo module enable nodejs18 version
dnf module enable nodejs:18 -y &>>$log_file

echo install NodeJS
dnf install nodejs -y &>>$log_file

echo configure the backend service
cp backend.service /etc/systemd/system/backend.service

echo creating application useradd
useradd expense

echo remove the existing app content
rm -rf /app

echo create new app directory
mkdir /app

echo download the application content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app

echo extracting application content
unzip /tmp/backend.zip &>>$log_file

echo downloading the application dependencies
npm install &>>$log_file


echo reloading the SystemD and Start Backend Service
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file

echo install the MYSQL server
dnf install mysql -y &>>$log_file
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
# mysql -h mysql-dev.mahicasa.online -uroot -pExpenseApp@1 < /app/schema/backend.sql