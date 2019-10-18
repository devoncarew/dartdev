// Copyright (c) 2017, Devon Carew. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';

import 'src/commands/analyze.dart';
import 'src/commands/create.dart';
import 'src/commands/format.dart';
import 'src/commands/pub.dart';
import 'src/commands/run.dart';
import 'src/commands/test.dart';
import 'src/core.dart';
import 'src/sdk.dart';

// TODO: doctor, fix, upgrade, channel?

// TODO: bash shell completion

// TODO: install dartdev?

// TODO: delegate to dartdev?

// TODO: create a 'fix' command?

// TODO: create a separate 'migrate' command?

// TODO: create a app native command? 'aot'?

// TODO: create a dart run command? For scripts, snapshots, activated tools?

// TODO: potential names:
//   - dart, dart_tool, drunner, drun, drt, dartr, dartc, dartt, darttool,
//   - dt, d, dartdev?

final String _descFragment = 'A unified tool for Dart development';

class WebCommandRunner extends CommandRunner {
  WebCommandRunner() : super('dartdev', '$_descFragment.') {
    argParser.addFlag('verbose',
        abbr: 'v', negatable: false, help: 'Show verbose output.');
    argParser.addFlag('color',
        negatable: true, help: 'Whether to use terminal colors.');
    argParser.addFlag('version',
        negatable: false, help: 'Reports the version of this tool.');

    addCommand(new AnalyzeCommand());
    //addCommand(new BuildCommand()); // necessary?
    addCommand(new CreateCommand());
    addCommand(new FormatCommand());
    addCommand(new PubCommand());
    addCommand(new RunCommand());
    //addCommand(new ServeCommand()); // necessary?
    addCommand(new TestCommand());
  }

  @override
  Future runCommand(ArgResults results) async {
    if (results.wasParsed('color')) {
      final bool useColor = results['color'];
      ansi = new Ansi(useColor);
    }

    if (results['version']) {
      print('${ansi.emphasized(executableName)} ${ansi.bullet} www.dart.dev');
      print('');
      print('$_descFragment; built on SDK ${ansi.emphasized(sdk.version)}.');
      return null;
    }

    isVerbose = results['verbose'];

    log = isVerbose
        ? new Logger.verbose(ansi: ansi)
        : new Logger.standard(ansi: ansi);

    return await super.runCommand(results);
  }
}
