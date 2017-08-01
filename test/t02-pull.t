#!/usr/bin/env bash

test_description='ds pull'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds pull wsproxy (cloning)' '
    rm -rf $TEMP_DIR/docker-scripts/wsproxy &&
    ds pull wsproxy 2>&1 | grep "Cloning into" &&
    [[ -d $TEMP_DIR/docker-scripts/wsproxy ]]
'

test_expect_success 'ds pull wsproxy (up to date)' '
    ds pull wsproxy 2>&1 | grep "Already up-to-date."
'

test_expect_success 'ds pull (with branch)' '
    ds pull ds gh-pages &&
    [[ -d $TEMP_DIR/docker-scripts/ds-gh-pages ]] &&
    [[ $(git -C $TEMP_DIR/docker-scripts/ds-gh-pages branch) == "* gh-pages" ]] &&
    rm -rf $TEMP_DIR/docker-scripts/ds-gh-pages
'

test_done
