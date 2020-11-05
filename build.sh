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

cd package && find ../patches -type f | sort | xargs -n1 patch -p 1 -i && cd -

node build.replace.js
sed -i '/^\/\/# sourceMappingURL=.*\.map$/d' package/build/src/*.js

cp package.patched.json package/package.json

if grep -qrE "google-auth-library" package; then
  echo "Error: google-auth-library still present"
  exit -1
fi

if grep -qrE "sourceMappingURL" package; then
  echo "Error: sourceMappingURL still present"
  exit -1
fi
