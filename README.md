# Steps to access Postgres database

# Access the containers shell 
docker exec -it <container-id> bash

# Login to Postgres
psql -U root -d demo

# List all databses
\l 

# Quit Postgres
\q 

# Exit from Postgres container
exit

# AWS CLI installation on Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

# AWS CLI installation on Windows
Download and run the AWS CLI MSI installer for Windows (64-bit):

https://awscli.amazonaws.com/AWSCLIV2.msi

Alternatively, you can run the msiexec command to run the MSI installer.


C:\> msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
For various parameters that can be used with msiexec, see msiexec on the Microsoft Docs website. For example, you can use the /qn flag for a silent installation.


C:\> msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /qn
To confirm the installation, open the Start menu, search for cmd to open a command prompt window, and at the command prompt use the aws --version command.


C:\> aws --version
aws-cli/2.15.30 Python/3.11.6 Windows/10 exe/AMD64 prompt/off