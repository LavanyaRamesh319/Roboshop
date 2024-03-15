script=$(real_path "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>install python<<<<<<<<<\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>add application user<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>create app dir<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>download app contentl<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[36m>>>>>>>>>>extract app content<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>>install dependencies<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>setup systemd service<<<<<<<<<\e[0m"
cp /home/centos/Roboshop/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>start payment service<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment