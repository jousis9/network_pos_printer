library network_pos_printer;

import 'dart:io';
import 'dart:math';

enum NetworkPOSPrinterUnderline { none, single, double }
enum NetworkPOSPrinterJustification { left, center, right }

class NetworkPOSPrinter {
  Socket socket;

  NetworkPOSPrinter({this.socket});

  String _esc = '\x1B';
  String _gs = '\x1D';

  static Future<NetworkPOSPrinter> connect(host, int port,
      {sourceAddress, Duration timeout}) {
    return Socket.connect(host, port,
            sourceAddress: sourceAddress, timeout: timeout)
        .then((socket) {
      return NetworkPOSPrinter(socket: socket);
    });
  }

  void writeAll(Iterable objects, [String separator = '']) {
    socket.writeAll(objects, separator);
  }

  void writeLine([Object obj = '']) {
    socket.writeln(obj);
  }

  void write(Object obj) {
    socket.write(obj);
  }

//  void writeLeftRight(String left, String right) {
//    setJustification(NetworkPrintJustification.left);
//    write(left);
//
//    setJustification(NetworkPrintJustification.right);
//    write(right);
//  }

  void cut() {
    socket.write('${_esc}@${_gs}V1');
  }

  void feed(int feed) {
    writeAll([_esc, 'd', feed]);
  }

  Future<dynamic> flush() {
    return socket.flush();
  }

  Future<dynamic> close() {
    return socket.close();
  }

  void setBold(bool bold) {
    writeAll([_esc, 'E', bold ? 1 : 0]);
  }

  void setInverse(bool inverse) {
    writeAll([_gs, 'B', inverse ? 1 : 0]);
  }

  void setTextSize(int width, int height) {
    var c = pow(2, 4) * (width - 1) + (height - 1);

    writeAll([_gs, '!', c]);
  }

  void setUnderline(NetworkPOSPrinterUnderline underline) {
    int value;

    switch (underline) {
      case NetworkPOSPrinterUnderline.none:
        value = 0;
        break;

      case NetworkPOSPrinterUnderline.single:
        value = 1;
        break;

      case NetworkPOSPrinterUnderline.double:
        value = 2;
        break;

      default:
        value = 0;
        break;
    }

    writeAll([_esc, '-', value]);
  }

  void setJustification(NetworkPOSPrinterJustification justification) {
    int value;

    switch (justification) {
      case NetworkPOSPrinterJustification.left:
        value = 0;
        break;

      case NetworkPOSPrinterJustification.center:
        value = 1;
        break;

      case NetworkPOSPrinterJustification.right:
        value = 2;
        break;

      default:
        value = 0;
        break;
    }

    writeAll([_esc, 'a', value]);
  }

  void resetToDefault() {
    writeAll([_esc, '@']);
  }

//  void beep() {
//    socket.writeAll(['\x1B', '(A', 4, 0, 48, 55, 3, 15]);
//  }

//  void setLineSpacing(int spacing) {
//    socket.writeAll(['\x1B', '3', spacing]);
//  }

  void destroy() {
    socket.destroy();
  }
}
