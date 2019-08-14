#!/bin/bash

set -xe

: ${POSTGRES_INSTALL_DIR:=/usr/local/pgsql}
export PATH=${POSTGRES_INSTALL_DIR}/bin:$PATH

if [ -d ${HOME}/workspace/vops ]; then
    VOPS_SRC_PATH=${HOME}/workspace/vops
else
    VOPS_SRC_PATH=vops_src
fi

pushd ${VOPS_SRC_PATH}
    USE_PGXS=true make -j32 install
popd
