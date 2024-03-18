app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[36m>>>>>>>>>> $1 <<<<<<<<<<\e[0m"
}
func_status_check(){
  if [ $1 -eq 0 ]; then
        echo -e "\e[32mSUCCESS\e[0m"
        else
        echo -e "\e32mFAILURE\e[0m"
        echo "Refer the log file /tmp/roboshop.log for more info"
        exit 1
  fi
}
func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
  func_print_head  "Copy mongodb"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    func_status_check $?


  func_print_head  "Install mongodb"
  dnf install mongodb-org-shell -y
    func_status_check $?


  func_print_head  "Load schema"
  mongo --host mongodb-dev.devopz1.online </app/schema/${component}.js
    func_status_check $?

  fi
  if ["${schema_setup}"=="mysql" ]; then
  func_print_head "install mysql"
  dnf install mysql -y
    func_status_check $?


  func_print_head "Load schema"
  mysql -h mysql-dev.devopz1.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
    func_status_check $?
fi
}

func_app_prereq(){

  func_print_head "create application user"
  useradd ${app_user} >/tmp/roboshop.log
    func_status_check $?


  func_print_head "create application directory"
  rm -rf /app
  mkdir /app
  func_status_check $?

  func_print_head "Download application content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    func_status_check $?

  func_print_head "extract application content"
  cd /app
  unzip /tmp/${component}.zip
    func_status_check $?

}

func_systemd_setup(){
        func_print_head "setup systemd service"
         cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
          func_status_check $?

         func_print_head "start ${component} service"
         systemctl daemon-reload
         systemctl enable ${component}
         systemctl restart ${component}
         func_status_check $?

}

func_nodejs(){

func_print_head "Configuring Nodejs repos"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

func_print_head "Install Nodejs"
  dnf install nodejs -y
  func_status_check $?


func_app_prereq

func_print_head "Nodejs dependencies"
  npm install
  func_status_check $?

  func_schema_setup
  func_systemd_setup

}

func_java(){
  func_print_head "Install Maven"
  dnf install maven -y >/tmp/roboshop.log
  func_status_check $?

  func_app_prereq

  func_print_head "download maven dependencies"
  mvn clean package
  func_status_check $?
  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup
  func_systemd_setup
}