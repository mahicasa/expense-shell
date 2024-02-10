MYSQL_PASSWORD=$1
log_file=/tmp/expense.log

Head() {
  Head " -e "\e[36m$1\e[0m"
}

Head "Disable the default version of NodeJS"
dnf module disable nodejs -y &>>$log_file

Head "module enable nodejs18 version"
dnf module enable nodejs:18 -y &>>$log_file

Head "install NodeJS"
dnf install nodejs -y &>>$log_file

Head "configure the backend service"
cp backend.service /etc/systemd/system/backend.service

Head "creating application useradd"
useradd expense

Head "remove the existing app content"
rm -rf /app

Head "create new app directory"
mkdir /app

Head "download the application content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app

Head "extracting application content"
unzip /tmp/backend.zip &>>$log_file

Head "downloading the application dependencies"
npm install &>>$log_file


Head "reloading the SystemD and Start Backend Service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file

Head "install the MYSQL server"
dnf install mysql -y &>>$log_file
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
# mysql -h mysql-dev.mahicasa.online -uroot -pExpenseApp@1 < /app/schema/backend.sql