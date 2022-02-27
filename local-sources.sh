#!/bin/bash

echo "[INFO]: Accessing gist for source list..."
curl https://gist.githubusercontent.com/Defirence/f50a41eec75d7b19ec9ae7bafb97344a/raw/a270e9fa2d2f32b1a4d20e39353f5f5f5a5caffd/sources.list > /etc/apt/sources.list
echo "[INFO]: Running a quick package update apt-cache..."
apt-get update