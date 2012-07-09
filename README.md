This shell script was created to get a vps up and running in a minimal time.


# Requirements:
  Must be run as root
  
  Debian 6

# Instructions:
  Run with the following command: 

    bash vSetup.sh yourServerIp yourDesiredUsername yourDesiredSSHPort
  
The script requires some input during the installation, don't just run it blindly. I wrote this in a very short time
just to get my vps up and running quickly, so you most probably will experience problems on different systems as there
is not error checking. The output when running the script is not very user friendly, but I will update this shortly. I
will also post what exactly the script does, meanwhile, you can look at the source.


This was tested on a Debian 6 32bit minimal template on OpenVZ VPS.


The script closely follows the following guide posted by Ben B. at SliceHost:
http://articles.slicehost.com/2009/3/31/debian-lenny-setup-page-1
