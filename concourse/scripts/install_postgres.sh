#!/bin/bash
set -xe

: ${POSTGRES_INSTALL_DIR:=/usr/local/pgsql}

if [ -d ${HOME}/workspace/postgres ]; then
    POSTGRES_SRC_PATH=${HOME}/workspace/postgres
else
    POSTGRES_SRC_PATH=postgres_src

    # Install lz4
    yum install -y lz4-devel

    # install docbook-style-xsl - required for docs installation
    yum install -y docbook-style-xsl
fi

pushd ${POSTGRES_SRC_PATH}
    ./configure ${EXTRA_CONFIGURE_FLAGS} CFLAGS='-O2 -fno-omit-frame-pointer' --enable-cassert --enable-debug --prefix=${POSTGRES_INSTALL_DIR}
    make -j32 install-world
popd

