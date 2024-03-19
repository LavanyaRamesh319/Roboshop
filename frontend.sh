script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "install nginx"
dnf install nginx -y &>>log_file
func_status_check $?

func_print_head "copy roboshop content"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>log_file
func_status_check $?

func_print_head "remove old app content"
rm -rf /usr/share/nginx/html/* &>>log_file
func_status_check $?

func_print_head "download app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>log_file
func_status_check $?

func_print_head "unzip frontend content"
cd /usr/share/nginx/html &>>log_file
unzip /tmp/frontend.zip &>>log_file
func_status_check $?

func_print_head "start service"
systemctl restart nginx &>>log_file
systemctl enable nginx &>>log_file
func_status_check $?