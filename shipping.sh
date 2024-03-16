script=$(real_path "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

echo -e "\e[36m>>>>>>>>>> Install Maven<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[36m>>>>>>>>>>create app user<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>create app directory<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>Download app content<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>>>extract app<<<<<<<<<\e[0m"
cd /app


echo -e "\e[36m>>>>>>>>>>unzip shipping <<<<<<<<<\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>>>download maven dependencies<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>install mysql<<<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[36m>>>>>>>>>>Load schema<<<<<<<<<\e[0m"
mysql -h mysql-dev.devopz1.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
systemctl restart shipping

echo -e "\e[36m>>>>>>>>>>setup systemd service<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>>start shipping service<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping