// Copyright (c) 2017, Devon Carew. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:dartdev/dartdev.dart';

Ansi ansi = new Ansi(Ansi.terminalSupportsAnsi);
Logger log;
bool isVerbose = false;

abstract class WebCommand extends Command {
  final String _name;
  final String _description;

  WebCommand(this._name, this._description);

  @override
  String get name => _name;

  @override
  String get description => _description;

  WebCommandRunner get webRunner => runner as WebCommandRunner;
}

Future<Process> startProcess(
  String executable,
  List<String> arguments, {
  String cwd,
}) {
  log.trace('$executable ${arguments.join(' ')}');
  return Process.start(executable, arguments, workingDirectory: cwd);
}

void routeToStdout(
  Process process, {
  bool logToTrace: false,
  void listener(String str),
}) {
  if (isVerbose) {
    _streamLineTransform(process.stdout, (String line) {
      logToTrace ? log.trace(line.trimRight()) : log.stdout(line.trimRight());
      if (listener != null) listener(line);
    });
    _streamLineTransform(process.stderr, (String line) {
      log.stderr(line.trimRight());
      if (listener != null) listener(line);
    });
  } else {
    _streamLineTransform(process.stdout, (String line) {
      logToTrace ? log.trace(line.trimRight()) : log.stdout(line.trimRight());
      if (listener != null) listener(line);
    });

    _streamLineTransform(process.stderr, (String line) {
      log.stderr(line.trimRight());
      if (listener != null) listener(line);
    });
  }
}

void routeToStdoutStreaming(Process process) {
  if (isVerbose) {
    _streamLineTransform(
        process.stdout, (line) => log.stdout(line.trimRight()));
    _streamLineTransform(
        process.stderr, (line) => log.stderr(line.trimRight()));
  } else {
    process.stdout.listen((List<int> data) => stdout.add(data));
    _streamLineTransform(
        process.stderr, (line) => log.stderr(line.trimRight()));
  }
}

void _streamLineTransform(Stream<List<int>> stream, handler(String line)) {
  stream
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen(handler);
}
