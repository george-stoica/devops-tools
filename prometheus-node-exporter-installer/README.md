# Prometheus Node Exporter installer
Installs Prometheus Node Exporter as a Systemd service on Linux machines.
Used CentOs distribution for tests.

## Run playbook
```
ansible-playbook -i ansible/node-exporter-inventory ansible/install_node_exporter.yaml
```