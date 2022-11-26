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

    cd /home/$Fuser/$Component
    npm install >> $Logfile
}

Settingsystemd() {
    echo -n "Setting up systemd service : "
    sed -i -e 's/MONGO_DNSNAME/172.31.24.78/' -e 's/REDIS_ENDPOINT/172.31.92.253/' -e 's/MONGO_ENDPOINT/172.31.24.78/' -e 's/CATALOGUE_ENDPOINT/172.31.17.159/' /home/$Fuser/$Component/systemd.service >> $Logfile && mv /home/$Fuser/$Component/systemd.service /etc/systemd/system/$Component.service >> $Logfile
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

Settingsystemd

StartingService

}


