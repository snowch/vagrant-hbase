#!/bin/sh

wget http://download1.rstudio.org/rstudio-0.98.507-amd64.deb
sudo apt-get install -y r-base r-base-dev libjpeg62
sudo dpkg -i rstudio-0.98.507-amd64.deb

