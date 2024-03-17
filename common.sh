app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[36m>>>>>>>>>> $1 <<<<<<<<<<\e[0m"
}

schema_setup(){
  if [ "$schema_setup" == "mongo" ] then
  print_head  "Copy mongodb"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

 print_head  "Install mongodb"
  dnf install mongodb-org-shell -y

 print_head  "Load schema"
  mongo --host mongodb-dev.devopz1.online </app/schema/${component}.js
  fi
}
func_nodejs(){
print_head "Configuring Nodejs repos"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

print_head "Install Nodejs"
  dnf install nodejs -y

print_head "add application user"
  useradd ${app_user}

print_head "Create application directory"
  rm -rf /app
  mkdir /app

print_head "download cart content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

print_head "unzip user content"
  unzip /tmp/${component}.zip
  cd /app

print_head "Nodejs dependencies"
  npm install

print_head "copy user system file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "start user service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  schema_setup
}