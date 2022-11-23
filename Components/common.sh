    ID=$(id -u)

if [ $ID -ne 0 ]; then
    echo "Execute as root user to proceed further"
    exit 1
fi

