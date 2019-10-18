#!/bin/bash

# Copyright (c) 2017, Devon Carew. Please see the AUTHORS file for details.
# All rights reserved. Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Verify that the libraries are error free.
dartanalyzer --fatal-warnings \
  bin/ \
  lib/ \
  test/

# Run the tests.
pub run test

# Smoke test the tool.
dart --enable-asserts bin/dartdev.dart -h
