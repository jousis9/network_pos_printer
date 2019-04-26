import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:network_pos_printer/network_pos_printer.dart';

void main() {
  test('catch error on invalid ip address', () {
    NetworkPrinter.connect('xxx.xxx.xxx.xxx', 9100).then((printer) {}).catchError((error) {
      print('error : ${error}');
      expect(() => error is SocketException, throwsStateError);
    });
  });
}
