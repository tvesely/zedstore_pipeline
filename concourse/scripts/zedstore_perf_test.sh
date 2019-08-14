#!/bin/bash

set -xe

: ${POSTGRES_INSTALL_DIR:=/usr/local/pgsql}

if [ -d ${HOME}/workspace/zedstore_pipeline ]; then
    export ZEDSTORE_PIPELINE_SRC_PATH=${HOME}/workspace/zedstore_pipeline
else
    export ZEDSTORE_PIPELINE_SRC_PATH=zedstore_pipeline
fi

${POSTGRES_INSTALL_DIR}/bin/psql -a -f ${ZEDSTORE_PIPELINE_SRC_PATH}/concourse/scripts/benchmark.sql |
    perl -MTerm::ANSIColor -ane "if (/^(Time:|-- )/) { print color('bold blue'); print $_; print color('reset');} else { print $_ }"
