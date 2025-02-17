#!/bin/bash
# Pulls latest pre-built node binary from GitHub and installs it as a systemd service.
# Intended for non-technical validators, assumes running on compatible Ubuntu.

#stop on errors
set -e

#helper function to create avalanchego.service file
create_service_file () {
  rm -f avalanchego.service
  echo "[Unit]">>avalanchego.service
  echo "Description=AvalancheGo systemd service">>avalanchego.service
  echo "StartLimitIntervalSec=0">>avalanchego.service
  echo "[Service]">>avalanchego.service
  echo "Type=simple">>avalanchego.service
  echo "User=$(whoami)">>avalanchego.service
  echo "WorkingDirectory=$HOME">>avalanchego.service
  if [ "$ipChoice" = "1" ]; then
    echo "ExecStart=$HOME/avalanche-node/avalanchego --plugin-dir=$HOME/avalanche-node/plugins --dynamic-public-ip=opendns --http-host=">>avalanchego.service
  else
    echo "ExecStart=$HOME/avalanche-node/avalanchego --plugin-dir=$HOME/avalanche-node/plugins --public-ip=$foundIP --http-host=">>avalanchego.service
  fi
  echo "Restart=always">>avalanchego.service
  echo "RestartSec=1">>avalanchego.service
  echo "[Install]">>avalanchego.service
  echo "WantedBy=multi-user.target">>avalanchego.service
  echo "">>avalanchego.service
}

#helper function to check for presence of curl, and install if missing
check_curl() {
if ! command -v curl &> /dev/null
then
    echo "curl could not be found, will install..."
    sudo apt-get install curl -y
fi
}

echo "AvalancheGo installer"
echo "---------------------"
echo "Preparing environment..."
foundIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
foundArch="$(uname -m)"                         #get system architecture
foundOS="$(uname)"                              #get OS
if [ "$foundOS" != "Linux" ]; then
  #sorry, don't know you.
  echo "Unsupported operating system: $foundOS!"
  echo "Exiting."
  exit
fi
if [ "$foundArch" = "aarch64" ]; then
  getArch="arm64"                               #we're running on arm arch (probably RasPi)
  echo "Found arm64 architecture..."
elif [ "$foundArch" = "x86_64" ]; then
  getArch="amd64"                               #we're running on intel/amd
  echo "Found 64bit Intel/AMD architecture..."
else
  #sorry, don't know you.
  echo "Unsupported architecture: $foundArch!"
  echo "Exiting."
  exit
fi
check_curl
if test -f "/etc/systemd/system/avalanchego.service"; then
  foundAvalancheGo=true
  echo "Found AvalancheGo systemd service already installed, switching to upgrade mode."
  echo "Stopping service..."
  sudo systemctl stop avalanchego
else
  foundAvalancheGo=false
fi
# download and copy node files
mkdir -p /tmp/avalanchego-install               #make a directory to work in
rm -rf /tmp/avalanchego-install/*               #clean up in case previous install didn't
cd /tmp/avalanchego-install

read -p "Press enter to install the latest AvalancheGo version, or specify the version to install (e.g. v1.2.3): " version
version=${version:-latest}
echo "Looking for $getArch version $version..."
if [ "$version" = "latest" ]; then
  fileName="$(curl -s https://api.github.com/repos/ava-labs/avalanchego/releases/latest | grep "avalanchego-linux-$getArch.*tar\(.gz\)*\"" | cut -d : -f 2,3 | tr -d \" | cut -d , -f 2)"
else
  fileName="https://github.com/ava-labs/avalanchego/releases/download/$version/avalanchego-linux-$getArch-$version.tar.gz"
fi

if [ "$fileName" = "" ]; then
  echo "Unable to find AvalancheGo version $version. Exiting."
  if [ "$foundAvalancheGo" = "true" ]; then
    echo "Restarting service..."
    sudo systemctl start avalanchego
  fi
  exit
fi
echo "Attempting to download: $fileName"
wget -nv --show-progress $fileName
echo "Unpacking node files..."
mkdir -p $HOME/avalanche-node
tar xvf avalanchego-linux*.tar.gz -C $HOME/avalanche-node --strip-components=1;
rm avalanchego-linux-*.tar.gz
echo "Node files unpacked into $HOME/avalanche-node"
echo
if [ "$foundAvalancheGo" = "true" ]; then
  echo "Node upgraded, starting service..."
  sudo systemctl start avalanchego
  echo "New node version:"
  $HOME/avalanche-node/avalanchego --version
  echo "Done!"
  exit
fi
echo "To complete the setup, some networking information is needed."
echo "Where is your node running?"
echo "1) Residential network (dynamic IP)"
echo "2) Cloud provider (static IP)"
ipChoice="x"
while [ "$ipChoice" != "1" ] && [ "$ipChoice" != "2" ]
do
  read -p "Enter your connection type [1,2]: " ipChoice
done
if [ "$ipChoice" = "1" ]; then
  echo "Installing service with dynamic IP..."
else
  read -p "Detected '$foundIP' as your public IP. Is this correct? [y,n]: " correct
  if [ "$correct" != "y" ]; then
    read -p "Enter your public IP: " foundIP
  fi
  echo "Installing service with public IP: $foundIP"
fi
create_service_file
chmod 644 avalanchego.service
sudo cp -f avalanchego.service /etc/systemd/system/avalanchego.service
sudo systemctl start avalanchego
sudo systemctl enable avalanchego
echo
echo "Done!"
echo
echo "Your node should now be bootstrapping on the main net."
echo "To check that the service is running use the following command (q to exit):"
echo "sudo systemctl status avalanchego"
echo "To follow the log use (ctrl-c to stop):"
echo "sudo journalctl -u avalanchego -f"
echo
echo "Reach us over on https://chat.avax.network if you're having problems."
