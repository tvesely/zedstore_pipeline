#!/bin/bash

set -xe

if [ -d ${HOME}/workspace/tpch-dbgen ]; then
    export TPCH_DATAGEN_SRC_PATH=${HOME}/workspace/tpch-dbgen
else
    export TPCH_DATAGEN_SRC_PATH=tpch_dbgen_src
fi

# Generate dataset
pushd ${TPCH_DATAGEN_SRC_PATH}
    make -j32
    ./dbgen -s ${SCALE_FACTOR} -T L -f
    cp lineitem.tbl /tmp/lineitem.tbl
popd
