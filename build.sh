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

cp package.patched.json package/package.json
