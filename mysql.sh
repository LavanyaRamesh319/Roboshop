script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z $mysql_root_password ]; then
  echo Input MySql Root Password Missing
  exit
fi

echo -e "\e[36m>>>>>>>>>>disable mysql default version<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>>>copy mysql repo file<<<<<<<<<\e[0m"
cp ${script_path}//mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>>>install mysql default version<<<<<<<<<\e[0m"
dnf install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>start mysql default version<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>>>reset mysql password <<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass $mysql_root_password
