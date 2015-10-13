#!/bin/bash

cd /vagrant

echo "Install project-specific dependencies"
bundle install > /dev/null

echo "Adding /vagrant/bin to user's path"
cp ~/.bashrc /tmp/
echo "# Add /vagrant/bin to user's path" > ~/.bashrc
echo "export PATH=\"/vagrant/bin:\$PATH\"" >> ~/.bashrc
echo "" >> ~/.bashrc
cat /tmp/.bashrc >> ~/.bashrc
