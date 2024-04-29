#! /bin/bash
curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.9.0/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy
sudo mv ./cloud-sql-proxy /usr/local/bin/
cloud-sql-proxy --address 0.0.0.0 --port 5432 --private-ip ${connection_name}
