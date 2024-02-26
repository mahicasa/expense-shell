component=frontend

source common.sh

Head "Install Nginx"
dnf install nginx -y &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

Head "Copy config"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi

App_Prereq "/usr/share/nginx/html"

Head "Start nginx service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit 1
fi