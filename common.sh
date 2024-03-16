app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_nodejs(){
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
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>>>>> unzip user content <<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>>>>> Nodejs dependencies <<<<<<<<<<\e[0m"
  npm install

  echo -e "\e[36m>>>>>>>>>> copy user system file <<<<<<<<<<\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>>>>>> start user service <<<<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}