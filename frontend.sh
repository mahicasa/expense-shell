component=frontend

source common.sh

Head "Install Nginx"
dnf install nginx -y &>>$log_file
echo $?

Head "Copy config"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?

App_Prereq "/usr/share/nginx/html"

Head "Start nginx service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
echo $?