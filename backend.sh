soure common.sh

Head "Disable the default version of NodeJS"
dnf module disable nodejs -y &>>$log_file
echo $?

Head "module enable nodejs18 version"
dnf module enable nodejs:18 -y &>>$log_file
echo $?

Head "install NodeJS"
dnf install nodejs -y &>>$log_file
echo $?

Head "configure the backend service"
cp backend.service /etc/systemd/system/backend.service
echo $?

Head "creating application useradd"
useradd expense
echo $?

Head "remove the existing app content"
rm -rf /app
echo $?

Head "create new app directory"
mkdir /app
echo $?

Head "download the application content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app
echo $?

Head "extracting application content"
unzip /tmp/backend.zip &>>$log_file
echo $?

Head "downloading the application dependencies"
npm install &>>$log_file
echo $?

Head "reloading the SystemD and Start Backend Service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
echo $?

Head "Install MySQL Client"
dnf install mysql -y &>>$log_file
echo $?

Head "Load Schema"
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
echo $?


# mysql -h mysql-dev.mahicasa.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
