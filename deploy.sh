#!/bin/bash

if [ -d ~/ruby-server ]; then
    rm -rf ~/ruby-server
fi

mkdir -p ~/ruby-server

cp -r . ~/ruby-server/