MYSQL_PASSWORD=$1
if [ -z "$MYSQL_PASSWORD" ]; then
  echo Input MYSQL_PASSWORD is missing
  exit 1
fi

component=backend

source common.sh

Head "Disable the default version of NodeJS"
dnf module disable nodejs -y &>>$log_file
Stat $?

Head "module enable nodejs18 version"
dnf module enable nodejs:18 -y &>>$log_file
Stat $?

Head "install NodeJS"
dnf install nodejs -y &>>$log_file
Stat $?

Head "configure the backend service"
cp backend.service /etc/systemd/system/backend.service
Stat $?

Head "creating application useradd"
id expense &>>$log_file
if [ "$?" -ne 0 ]; then
  useradd expense &>>$log_file
fi
Stat $?

App_Prereq "/app"

Head "downloading the application dependencies"
npm install &>>$log_file
Stat $?

Head "reloading the SystemD and Start Backend Service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
Stat $?

Head "Install MySQL Client"
dnf install mysql -y &>>$log_file
Stat $?

Head "Load Schema"
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
Stat $?


# mysql -h mysql-dev.mahicasa.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
