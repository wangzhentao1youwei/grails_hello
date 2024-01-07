#!/bin/sh
sudo service tomcat stop
#sudo rm -rf /mnt/tomcat/webapps/web*
sudo chmod o+w /mnt/tomcat/*
#sudo cp target/web.war /mnt/tomcat/webapps
sudo chmod o+w /mnt/bizweb/log/bizweb.log
sudo service tomcat start
#tail -f /mnt/bizweb/log/bizweb.log
