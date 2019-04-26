import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:network_pos_printer/network_pos_printer.dart';

void main() {
  test('catch error on invalid ip address', () {
    NetworkPOSPrinter.connect('xxx.xxx.xxx.xxx', 9100)
        .then((printer) {})
        .catchError((error) {
      expect(() => error is SocketException, throwsStateError);
    });
  });
}
