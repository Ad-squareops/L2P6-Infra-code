#!/bin/bash
#NodeJS Dependencies
sudo apt update
sudo apt install net-tools -y
curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm install pm2@latest -g

#AmazonCodeDeploy Agent
sudo apt update -y
sudo apt install ruby wget -y
wget https://aws-codedeploy-ca-central-1.s3.ca-central-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent.service
sudo systemctl enable codedeploy-agent.service
sudo systemctl status codedeploy-agent.service

#AmazonCloudWatch Agent
sudo apt update -y
sudo mkdir /tmp/cwa
cd /tmp/cwa
sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip -O AmazonCloudWatchAgent.zip
sudo apt install -y unzip
sudo unzip -o AmazonCloudWatchAgent.zip
sudo ./install.sh
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-linux-adi-L2P6 -s
systemctl start amazon-cloudwatch-agent.service
systemctl enable amazon-cloudwatch-agent.service
systemctl status amazon-cloudwatch-agent.service
