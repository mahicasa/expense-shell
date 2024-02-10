log_file=/tmp/expense.log

Head() {
  echo -e "\e[36m$1\e[0m"
}

Head "Install Nginx"
dnf install nginx -y &>>$log_file
echo $?

Head "Copy config"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?

Head "Remove the default content that web server is serving"
rm -rf /usr/share/nginx/html/* &>>$log_file
echo $?

Head "Download the frontend content"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
echo $?

Head "Extract the frontend content"
cd /usr/share/nginx/html &>>$log_file
echo $?

unzip /tmp/frontend.zip

Head "Enable nginx"
systemctl enable nginx &>>$log_file
echo $?

Head "Restart nginx"
systemctl restart nginx &>>$log_file
echo $?