#!/usr/bin/env bash

test_description='Test: ds pull'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds pull (cloning)' '
    rm -rf $APPS/ds &&
    ds pull ds 2>&1 | grep "Cloning into" &&
    [[ -d $APPS/ds ]]
'

test_expect_success 'ds pull (up to date)' '
    ds pull ds 2>&1 | grep "Already up-to-date."
'

test_expect_success 'ds pull (with branch)' '
    ds pull ds gh-pages &&
    [[ -d $APPS/ds-gh-pages ]] &&
    [[ $(git -C $APPS/ds-gh-pages branch) == "* gh-pages" ]] &&
    rm -rf $APPS/ds-gh-pages
'

test_expect_success 'ds pull dummy (not found)' '
    ds pull dummy 2>&1 | grep "not found"
'

test_expect_success 'ds pull (usage)' '
    ds pull 2>&1 | grep "Usage:"
'

test_done
