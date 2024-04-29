# Tools

```bash
❯ brew install tfenv
❯ tfenv --version
tfenv 3.0.0
❯ tfenv use 1.7.3
❯ terraform --version
Terraform v1.7.3
on darwin_amd64
❯ infracost --version
Infracost v0.10.33

❯ brew install --cask google-cloud-sdk
❯ gcloud --version
Google Cloud SDK 464.0.0
bq 2.0.101
core 2024.02.09
gcloud-crc32c 1.0.0
gsutil 5.27

❯ gcloud config configurations create FUGA
❯ gcloud config set project HOGE
❯ gcloud config set account YOUR_EMAIL@DOMAIN
# https://blog.g-gen.co.jp/entry/difference-of-gloud-auth-commands
# printf %s 'SELECT * from credentials;' | sqlite3 ~/.config/gcloud/credentials.db
❯ gcloud auth login
❯ gcloud config set compute/zone asia-northeast1-a
❯ gcloud config set compute/region asia-northeast1
```

# Architecture

![architecture](./.excalidraw.png)


# App

```shell
❯ gcloud run services proxy $(terraform output -raw cloudrun_name)
...
Please enter numeric choice or text value (must exactly match list item):  4

To make this the default region, run `gcloud config set run/region asia-northeast1`.

Proxying to Cloud Run service [xxxxxx] in project [xxxxx] region [asia-northeast1]
http://127.0.0.1:8080 proxies to https://XXXXXXXXXXXXX.a.run.app
```

More simple way

```shell
❯ curl -I -H "Authorization: Bearer $(gcloud auth print-identity-token)" $(terraform output -raw cloudrun_uri )
HTTP/2 200
content-type: text/html; charset=utf-8
date: Mon, 26 Feb 2024 06:19:08 GMT
server: Google Frontend
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

# DB

- Identity-Aware Proxy / bastion (private GCE) / Cloud SQL Auth Proxy
- TablePlus

```bash
❯ gcloud compute start-iap-tunnel bastion 5432 --local-host-port=localhost:15432 --zone=asia-northeast1-a

Testing if tunnel connection works.
Listening on port [15432].
```
