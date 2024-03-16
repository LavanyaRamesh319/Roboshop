script=$(real_path "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

echo -e "\e[36m>>>>>>>>>>setup Erlang repos<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>setup rabbitmq repos<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>install rabbitmq and erlang<<<<<<<<<\e[0m"
dnf install erlang rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>>start rabbitmq<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>>>add application user in rabbitmq<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"