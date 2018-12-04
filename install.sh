#!/bin/sh
# Author: Ravi Shankar (rvishnkr)
# Installer script to setup adapt-lidar-tools and build the executables

#### Display usage
display_usage() { 
  printf "\nTo install adapt-lidar-tools, run the install script from the root of the cloned repository folder\n"
	printf "Usage:\t`basename $0` [-h]\n" 
}

### Exit immediately if a command exits with a non-zero status.
set -e

### 'trap' defines and activates handlers to be run when the shell receives 
###	signals or other special conditions
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG

### Abort on a failed commands
trap 'printf "\nexit $? due to:\n\t$previous_command\n"' EXIT

### Check arguments
if [ "$1" == "-h" ] || [ "$1" == "help" ]; then
	display_usage
  exit 0
elif [ -z "$1" ] ### If no arguments, continue runnng the script
then
  echo "----------------------------"
  echo "Setting up adapt-lidar-tools"
  echo "----------------------------"
else
  printf "Invalid arguments. Exiting\n"
  exit 1
fi

### Initialize and update submodules
printf "Initializing submodules\n"
git submodule init
printf "####                      (25%%)\n"
sleep 2

echo "Updating submodules"
git submodule update
printf "###########               (50%%)\n"
sleep 2

### Change 'atoill' to 'atoll'
echo "Updating PulseWaves"
cd deps/PulseWaves/src
sed -i 's/atoill/atoll/g' pulsefilter.cpp
sed -i 's/atoill/atoll/g' pulsetransform.cpp
make libpulsewaves.a
printf "##############            (75%%)\n"
sleep 2

### Build the pls-to-geotiff driver
echo "Building geotiff-driver in bin/"
cd ../../../
make geotiff-driver
printf "################          (90%%)\n"
sleep 2

### Build the pls-info tool
echo "Building pls-info tool in bin/"
make pls-info
printf "###################       (100%%)\ni\n"
sleep 2

printf "\nRun the executables from the $(pwd)/bin directory\n"
printf "Alternately, you may add the directory to your Environment Path\n"

echo "Do you wish to add $(pwd)/bin to your environment path?"
select yn in "Yes" "No"; do
    case $yn in
        Yes) 
		echo "yes!"; 
		echo "export PATH=\$PATH:$(pwd)/bin" >> ~/.bash_profile
		source ~/.bash_profile
		printf "\nInstallation complete.\n" 
		printf "Please run \"source ~/.bash_profile\" or restart your session!\n"
		break;;
        No) 
		echo "no"; break;;
    esac
done

printf "\nInstallation complete. Have a nice day!\n"
exit 0
