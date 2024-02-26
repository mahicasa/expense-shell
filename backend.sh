MYSQL_PASSWORD=$1

component=backend

source common.sh

Head "Disable the default version of NodeJS"
dnf module disable nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "module enable nodejs18 version"
dnf module enable nodejs:18 -y &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "install NodeJS"
dnf install nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "configure the backend service"
cp backend.service /etc/systemd/system/backend.service
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "creating application useradd"
useradd expense
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

App_Prereq "/app"

Head "downloading the application dependencies"
npm install &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "reloading the SystemD and Start Backend Service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "Install MySQL Client"
dnf install mysql -y &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "Load Schema"
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi


# mysql -h mysql-dev.mahicasa.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
