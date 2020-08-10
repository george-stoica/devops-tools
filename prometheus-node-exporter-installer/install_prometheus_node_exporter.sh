#!/bin/sh

set -e
set -u

# node_exporter needs to run under a new user
useradd --shell /sbin/nologin node_exporter

# create config dir for node_exporter
mkdir /var/lib/node_exporter

# change owner of config dir to node_exporter user
chown -v node_exporter:node_exporter /var/lib/node_exporter/

mkdir -vp /etc/sysconfig/

# create config file
echo OPTIONS="--collector.textfile.directory /var/lib/node_exporter/textfile_collector" > /etc/sysconfig/node_exporter

# allow reads for other users
chmod o+r /etc/sysconfig

mkdir -vp /usr/share/node_exporter
cd /usr/share/node_exporter

# download node_exporter
curl -L -O https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz

chown -v node_exporter:node_exporter /usr/share/node_exporter

# create service
sudo tee -a /etc/systemd/system/node_exporter.service << END
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/share/node_exporter/node_exporter-1.0.1.linux-amd64/node_exporter \$OPTIONS
[Install]
WantedBy=multi-user.target
END

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter