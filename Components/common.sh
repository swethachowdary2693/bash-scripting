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
systemctl enable $1  >> /tmp/frontend
Status $2

echo -n "Start $1 : "
systemctl start $1 >> /tmp/frontend
Status $2

}