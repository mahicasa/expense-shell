dnf install nginx -y #Install Nginx
systemctl enable nginx
systemctl start nginx

rm -rf /usr/share/nginx/html/* #Remove the default content that web server is serving

curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip #Download the frontend content#

cd /usr/share/nginx/html #Extract the frontend content
unzip /tmp/frontend.zip
