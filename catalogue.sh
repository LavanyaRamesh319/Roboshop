echo -e "\e[36m>>>>>>>>>> Configuring Nodejs repos <<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>>>>>> Install Nodejs <<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>> add application user <<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>> Create application directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> download app content <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>>> unzip app content <<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>>> Nodejs dependencies <<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>> copy catalogue system file <<<<<<<<<<\e[0m"
cp /home/centos/Roboshop/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>> start catalogue service <<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>>> Copy mongodb repo <<<<<<<<<<\e[0m"
cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>> Install mongodb <<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
mongo --host mongodb-dev.devopz1.online </app/schema/catalogue.js