#!/bin/bash

export GITHUB_ORG="${github_org}"
export RUNNER_TOKEN="${runner_token}"
export RUNNER_NAME="${runner_name}"
export RUNNER_LABELS="${runner_labels}"
export RUNNER_GROUP="${runner_group}"
export DEBIAN_FRONTEND=noninteractive
#TODO run as unprivileged user.
export RUNNER_ALLOW_RUNASROOT="1"

echo whoami | tee -a ./output.txt
echo pwd | tee -a ./output.txt

mkdir ./actions-runner
cd ./actions-runner

mkdir ./_work
curl -o actions-runner-linux-x64-2.294.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.294.0/actions-runner-linux-x64-2.294.0.tar.gz
tar -xzf ./actions-runner-linux-x64-2.294.0.tar.gz
rm ./actions-runner-linux-x64-2.294.0.tar.gz

./config.sh \
  --url "https://github.com/$GITHUB_ORG" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --work "_work" \
  --labels "$RUNNER_LABELS" \
  --runnergroup "$RUNNER_GROUP" \
  --unattended \  \
  --replace

sudo ./svc.sh install
sudo ./svc.sh start
