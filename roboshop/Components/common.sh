    ID=$(id -u)

if [ $ID -ne 0 ]; then
    echo "Execute as root user to proceed further"
    exit 1
fi

Status() {
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success \e[0m"
    else    
        echo -e "\e[32m Failed in installing \e[0m"
    fi
}

Sysctl() {

echo -n "Enable $1 : "
systemctl enable $1  >> $Logfile
Status $2

echo -n "Start $1 : "
systemctl start $1 >> $Logfile
Status $2

}

Fuser=roboshop
Logfile=/tmp/robot.log

Useradd() {
    echo -n "Create Application user :"
    id $Fuser >> $Logfile || useradd $Fuser
    Status $?
}

DownloadExtract() {
    echo -n "Download the $Component :"
    rm -rf /home/$Fuser/$Component >> $Logfile
    curl -s -L -o /tmp/$Component.zip "https://github.com/stans-robot-project/$Component/archive/main.zip" >> $Logfile
    cd /home/$Fuser 
    unzip -o /tmp/$Component.zip >> $Logfile && mv $Component-main $Component
    Status $?

    echo -n "Changing ownership : "
    chown -R $Fuser:$Fuser $Component/  >> $Logfile
    Status $?

}

npminstall() {
    cd /home/$Fuser/$Component
    npm install >> $Logfile
}

Settingsystemd() {
    echo -n "Setting up systemd service : "
    sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/$Fuser/$Component/systemd.service >> $Logfile && mv /home/$Fuser/$Component/systemd.service /etc/systemd/system/$Component.service >> $Logfile
    Status $?
}

StartingService() {
    echo -n "Restarting the service : "
    systemctl daemon-reload   >> $Logfile
    systemctl start $Component  >>  $Logfile
    systemctl enable $Component  >> $Logfile
Status $? 
}

NodeJs() {
    echo -n "Installing NodeJs : "
    curl -sL https://rpm.nodesource.com/setup_16.x | bash >> $Logfile
    yum install nodejs -y  >> $Logfile
    Status $?

Useradd

DownloadExtract

npminstall

Settingsystemd

StartingService

}

Maven(){
    echo -n "Installing Maven : "
    yum install $Component -y >> $Logfile
    Status $?

    Useradd

    DownloadExtract

    echo -n "Generating the artifact : "
    cd /home/$Fuser/$Component
    mvn clean package  &>> $Logfile
    mv target/$Component-1.0.jar $Component.jar &>> $Logfile
    Status $?
}


