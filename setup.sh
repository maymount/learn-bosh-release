#!/bin/bash -xe

# git clone https://github.com/cloudfoundry/bosh-deployment bosh-deployment
# mkdir vbox

# Create environment

cd ~/workspace/

bosh create-env bosh-deployment/bosh.yml \
--state vbox/state.json \
-o bosh-deployment/virtualbox/cpi.yml \
-o bosh-deployment/virtualbox/outbound-network.yml \
-o bosh-deployment/bosh-lite.yml \
-o bosh-deployment/bosh-lite-runc.yml \
-o bosh-deployment/jumpbox-user.yml \
--vars-store vbox/creds.yml \
-v director_name="Bosh Lite Director" \
-v internal_ip=192.168.50.6 \
-v internal_gw=192.168.50.1 \
-v internal_cidr=192.168.50.0/24 \
-v outbound_network_name=NatNetwork

bosh alias-env vbox -e 192.168.50.6 --ca-cert <(bosh int ~/workspace/vbox/creds.yml --path /director_ssl/ca)
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ~/workspace/vbox/creds.yml --path /admin_password`

# sudo route add -net 10.244.0.0/16     192.168.50.6

bosh -e vbox login

# Get stemcell

wget -o ubuntu-trusty.tgz https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent

bosh -e vbox upload-stemcell ubuntu-trusty.tgz

# Create release

cd ~/workspace/learn-bosh-release

bosh create-release --force && bosh -e vbox upload-release && bosh -e vbox -d learn-bosh deploy manifest.yml

