#!/usr/bin/env bash

test_description='Trivial checks'
source "$(dirname "$0")"/setup.sh

test_expect_success 'ls -al' '
    ls -al
'

test_done
