#!/bin/bash

cd /vagrant

echo "Install project-specific dependencies"
bundle install > /dev/null
