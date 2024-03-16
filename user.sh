script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>> Configuring Nodejs repos <<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>>>>>> Install Nodejs <<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>> add application user <<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>> Create application directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> download app content <<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>>>>>> unzip app content <<<<<<<<<<\e[0m"
unzip /tmp/user.zip
cd /app

echo -e "\e[36m>>>>>>>>>> Nodejs dependencies <<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>> copy user system file <<<<<<<<<<\e[0m"
cp ${script_path}/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>>> start user service <<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>>>>>> Copy mongodb repo <<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>> Install mongodb <<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>> Load schema <<<<<<<<<<\e[0m"
mongo --host mongodb-dev.devopz1.online </app/schema/user.js