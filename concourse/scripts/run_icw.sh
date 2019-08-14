#!/bin/bash

set -ex

function look4diffs() {

    diff_files=`find .. -name regression.diffs`

    for diff_file in ${diff_files}; do
	if [ -f "${diff_file}" ]; then
	    cat <<-EOF

				======================================================================
				DIFF FILE: ${diff_file}
				----------------------------------------------------------------------

				$(cat "${diff_file}")

			EOF
	fi
    done
    exit 1
}

# Set up postgres user
getent passwd postgres|| useradd postgres

zedstore_pipeline/concourse/scripts/install_postgres.sh
su -c "zedstore_pipeline/concourse/scripts/initdb.sh" postgres

chown -R postgres:postgres postgres_src


pushd postgres_src
  PGUSER=postgres ${POSTGRES_INSTALL_DIR}/bin/psql -c "ALTER SYSTEM SET default_table_access_method=${DEFAULT_TABLE_ACCESS_METHOD}"
  su -c "${POSTGRES_INSTALL_DIR}/bin/pg_ctl -D /tmp/pg_db reload" postgres
  trap look4diffs ERR
  su -c "EXTRA_REGRESS_OPTS=${EXTRA_REGRESS_OPTS} PGOPTIONS=${PGOPTIONS} make installcheck-world" postgres
popd
