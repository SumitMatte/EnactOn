# Follow the below instructions take backup from github using rclone and upload to the google drive 
# To install rclone
 sudo apt update
 sudo apt-get install rclone -y
# Run below command to configure rclone
 rclone config
# Ater running above command rclone wizard will be appeared, reffer following docx
  https://rclone.org/drive/
# after configuring rclone authentication required for that you have to copy url to browser and give permission
# It will work for local machine, if you are using virtual machine(EC2) then you have to create tunnel between vm and local machine
   ssh -i key-pair.pem -L 53682:localhost:53682 ubuntu@ip-addess _n
# Now copy url and gave permission
# Also you can mount google drive on your machin by using following command
  nohup rclone mount gdrive: ~/backup-dir &
  # At last to take backup and to store it on google drive run script
  
