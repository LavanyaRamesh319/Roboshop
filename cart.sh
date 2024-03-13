script_path=$(dirname $0)
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

echo -e "\e[36m>>>>>>>>>> download cart content <<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>> unzip user content <<<<<<<<<<\e[0m"
unzip /tmp/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>> Nodejs dependencies <<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>> copy user system file <<<<<<<<<<\e[0m"
cp ${script_path}/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>>> start user service <<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
