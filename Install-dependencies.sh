#!/bin/bash

sudo apt install make gcc libncurses5-dev python3 python3-numpy python3-pi python-is-python3 unzip default-jre

mkdir Tools
cd Tools/
wget https://github.com/DerrickWood/kraken2/archive/v2.1.1.tar.gz && tar xvf v2.1.1.tar.gz && rm -f v2.1.1.tar.gz
cd kraken2-2.1.1/
./install_kraken2.sh ../Kraken2

cd ..

mkdir Kraken2/db
cd Kraken2/db/
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_8gb_20201202.tar.gz && tar xvf k2_standard_8gb_20201202.tar.gz && rm -f k2_standard_8gb_20201202.tar.gz

cd ../..

wget https://github.com/jenniferlu717/Bracken/archive/v2.6.0.tar.gz && tar xzf v2.6.0.tar.gz && rm -f v2.6.0.tar.gz
cd Bracken-2.6.0/
./install-bracken ../bracken

cd ..

wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip && unzip Trimmomatic-0.38.zip && rm -f Trimmomatic-0.38.zip

cd ~

curl -fsSL get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/

## The following will install everything required to run singularity

sudo apt install build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools
export VERSION=1.15 OS=linux ARCH=amd64
cd /tmp/
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
sudo tar -C /usr/local/ -xzf go1.15.6.linux-amd64.tar.gz
cd ~
echo 'export GOPATH=${HOME}/go' >> ~/.bashrc
echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc
source ~/.bashrc 
mkdir -p $GOPATH/src/github.com/sylabs
cd $GOPATH/src/github.com/sylabs
git clone https://github.com/sylabs/singularity.git
cd singularity/
go get -u -v github.com/golang/dep/cmd/dep
./mconfig 
make -C builddir
sudo make -C builddir install
cd ~

## Any nf-core pipelines can now be run using singularity with out having to install other dependencies ##