#!/bin/bash
set -e

: ${CHANGELOG_FILE:="changelog.xml"}
: ${CHANGESET_PATH:="$(dirname $SOURCE_PATH/$CHANGELOG_FILE)/changesets"}
: ${CHANGESET_FILE:="changeset_$(date +%F_%H-%M).xml"}
: ${LIQUIBASE_AUTHOR:="liquibase"}

if [[ ! -d $CHANGESET_PATH ]]; then
  mkdir -p $CHANGESET_PATH
fi

LIQUIBASE_OPTIONS=" --changeLogFile=${CHANGESET_PATH}/${CHANGESET_FILE} --changeSetAuthor=${LIQUIBASE_AUTHOR}"

if [[ $LIQUIBASE_DEBUG == 1 ]]; then
    LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --logLevel=debug"
fi

if [[ ! -z $LIQUIBASE_DB_SCHEME  ]]; then
  LIQUIBASE_OPTIONS="$LIQUIBASE_OPTIONS --defaultSchemaName=${LIQUIBASE_DB_SCHEME}"
fi

liquibase $LIQUIBASE_OPTIONS generateChangeLog

if [[ -f ${SOURCE_PATH}/${CHANGESET_FILE}  ]]; then
    echo 'Changelog gerado em' ${SOURCE_PATH}/${CHANGESET_FILE}
fi

if [[ ! -f  $SOURCE_PATH/$CHANGELOG_FILE ]]; then
    cp $BINARY_PATH/changelog.template.xml $SOURCE_PATH/$CHANGELOG_FILE 
fi

sed -i "/<\/databaseChangeLog>/i    <include relativeToChangelogFile=\"true\" file=\"changesets/$CHANGESET_FILE\" />" "${SOURCE_PATH}/${CHANGELOG_FILE}"