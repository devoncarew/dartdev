// Copyright (c) 2017, Devon Carew. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

/// The directory used to store per-user settings for Dart tooling.
Directory getDartPrefsDirectory() {
  return new Directory(path.join(getUserHomeDir(), '.dart'));
}

/// Return the user's home directory.
String getUserHomeDir() {
  String envKey = Platform.operatingSystem == 'windows' ? 'APPDATA' : 'HOME';
  String value = Platform.environment[envKey];
  return value == null ? '.' : value;
}

/// A typedef to represent a function taking no arguments and with no return
/// value.
typedef void VoidFunction();

final NumberFormat _numberFormat = new NumberFormat.decimalPattern();

/// Convert the given number to a string using the current locale.
String formatNumber(int i) => _numberFormat.format(i);

/// Emit the given word with the correct pluralization.
String pluralize(String word, int count) => count == 1 ? word : '${word}s';
