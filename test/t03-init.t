#!/usr/bin/env bash

test_description='Test: ds init'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ds init (with target)' '
    rm -rf $CONTAINERS/wsproxy1 &&
    ds pull wsproxy &&
    ds init wsproxy @wsproxy1 &&
    [[ -d $CONTAINERS/wsproxy1 ]] &&
    [[ -f $CONTAINERS/wsproxy1/settings.sh ]]
'

test_expect_success 'ds init (current dir)' '
    rm -rf $CONTAINERS/wsproxy2 &&
    mkdir -p  $CONTAINERS/wsproxy2 &&
    cd $CONTAINERS/wsproxy2 &&
    ds init wsproxy &&
    [[ -f $CONTAINERS/wsproxy2/settings.sh ]]
'

test_expect_success 'ds init (already exists)' '
    [[ -f $CONTAINERS/wsproxy1/settings.sh ]] &&
    cd $CONTAINERS/wsproxy1 &&
    ds init wsproxy 2>&1 | grep "already exists" &&
    ds init wsproxy @wsproxy2 2>&1 | grep "already exists"
'

test_expect_success 'ds init (wrong params)' '
    rm -rf $CONTAINERS/wsproxy1 &&
    mkdir -p $APPS/wsproxy2 &&
    ds init 2>&1 | grep "Usage:" &&
    ds init wsproxy1 2>&1 | grep "Cannot find directory" &&
    ds init wsproxy wsproxy1 2>&1 | grep "Usage:" &&
    ds init wsproxy2 @wsproxy1 2>&1 | grep "There is no file"
'

test_done
