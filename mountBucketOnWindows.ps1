##Enter your Access Key
$access_key=""

##Enter your Secret Key
$secret_key=""

##Enter your Bucket Name
$bucket_name=""

##Enter object storage namespace
$namespace=""

##Enter desired mount folder path
$mount_dir=""

##Enter region code e.g. ap-hyderabad-1
$region=""

## Installing Chocolatey if not done already
$chocovers = choco -v
if(!$chocovers){
	Set-ExecutionPolicy Bypass -Scope Process -Force;
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

## Installing Rclone and WinFSP
choco install rclone -y
choco install winfsp -y

##Configuring Rclone to access OCI bucket
New-Item ~\.rclone.conf
$rcloneconf = @"
[oci]
type=s3
region=$region
access_key_id=$access_key
secret_access_key=$secret_key
endpoint=https://$namespace.compat.objectstorage.$region.oraclecloud.com
"@
Add-Content ~\.rclone.conf $rcloneconf

##Mounting bucket
rclone mount oci:/$bucket_name $mount_dir/$bucket_name --vfs-cache-mode full