# bash-scripting

This is the repository for automation of Roboshop project

#### I will be giving names based on the components

#### Few basic commands which are used during this journey

1) git clone repository       :   Downloads the whole repository
2) git pull                   :   Downloads only the change
3) git add filename           :   Git will start tracking the changes make on the file with name filename
4) git add .                  :   Git will start tracking all the changes
5) git commit -m "msg name"   :   Adding msg to the commit / changes that we made
6) git push                   :   The changes will be pushed to the repository

#### Everytime we have to ensure that we are inside the repository to execute git commands
#### We will perform clone once and pull multiple times

## Main Project details:

In this we are automating roboshop project using bash scripting.

Components for roboshop project are below, 

1) Frontend
2) MongoDB
3) Catalogue
4) Redis
5) User
6) Cart
7) Mysql
8) Shipping
9) RabbitMq
10) Payment

In this we have implemented all the components under respective machine by just giving "sudo make Component"
    Note: Component will be the respective Component name

### In the above approach we are manually creating the machines and making the components. 

So we have automatted the creation of workstations and respective Route 53 record for each component. 

### In this above approach also we are manually giving each and every component name. 

Going forward we have automatted the creation of all workstations and respective Route 53 records for each component in a single go
   Example: bash launch_ec2.sh all 
   The above commands creates all the components in a single go. In this all is the input given from the command line. 
