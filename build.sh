#!/bin/bash

v="1.1.3"

rm -rf package *tgz
npm pack "@grpc/grpc-js@$v"
tar -xf "grpc-grpc-js-${v}.tgz"
rm -rf *tgz

rm -rf package/src package/deps
find package -name "*.ts" -delete
find package -name "*.map" -delete

rm -rf package/build/src/{events,load-balancer-eds,object-stream,xds-client,xds-bootstrap}.js
sed -i "/const GoogleAuth = require('google-auth-library')/d" package/build/src/channel-credentials.js
sed -i "s/    \.GoogleAuth/throw new Error('unimplemented')/" package/build/src/channel-credentials.js

cd package && find ../patches -type f | sort | xargs -n1 patch -p 1 -i && cd -

cp package.patched.json package/package.json

if grep -qrE "google-auth-library" package; then
  echo "Error: google-auth-library still present"
  exit -1
fi
