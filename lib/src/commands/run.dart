// Copyright (c) 2017, Devon Carew. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import '../core.dart';
import '../sdk.dart';

class RunCommand extends WebCommand {
  RunCommand() : super('run', "Run a Dart script or snapshot.") {
    // argParser.addFlag('live',
    //     negatable: false,
    //     help: 'Watch the filesystem for changes and reload the app.');
    // argParser.addOption('mode',
    //     defaultsTo: 'debug',
    //     allowed: ['release', 'debug'],
    //     help: 'The build mode (release or debug).');
  }

  // @override
  // String get summary {
  //   return '${super.summary}\n'
  //       'Use with --live to watch the filesystem and auto-refresh Chrome.';
  // }

  @override
  String get invocation => '${super.invocation} <file>';

  @override
  run() async {
    // todo: check for args == 0

    if (argResults.rest.length > 1) {
      usageException(
          'Too many entry-point files given: ${argResults.rest.join(' ')}');
      return 1;
    }

    String script = argResults.rest.first;

    // todo:
    print('run script: $script');

    final Process process = await startProcess(sdk.dart, [script]);
    routeToStdoutStreaming(process);
    return process.exitCode;
  }
}
