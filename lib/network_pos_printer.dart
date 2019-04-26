library network_pos_printer;

import 'dart:io';

enum NetworkPOSPrinterUnderline { none, single_weight, double_weight }
enum NetworkPOSPrinterJustification { left, center, right }

class NetworkPOSPrinter {
  Socket socket;

  NetworkPOSPrinter({this.socket});

  static Future<NetworkPOSPrinter> connect(host, int port,
      {sourceAddress, Duration timeout}) {
    return Socket.connect(host, port).then((socket) {
      return NetworkPOSPrinter(socket: socket);
    });
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
    socket.write('\x1B@\x1DV1');
  }

  void feed(int feed) {
    socket.writeAll(['\x1B', 'd', feed]);
  }

  Future<dynamic> flush() {
    return socket.flush();
  }

  Future<dynamic> close() {
    return socket.close();
  }

  void setBold(bool bold) {
    socket.writeAll(['\x1B', 'E', bold ? 1 : 0]);
  }

  void setInverse(bool inverse) {
    socket.writeAll(['\x1D', 'B', inverse ? 1 : 0]);
  }

  void setUnderline(NetworkPOSPrinterUnderline underline) {
    int value;

    switch (underline) {
      case NetworkPOSPrinterUnderline.none:
        value = 0;
        break;

      case NetworkPOSPrinterUnderline.single_weight:
        value = 1;
        break;

      case NetworkPOSPrinterUnderline.double_weight:
        value = 2;
        break;

      default:
        value = 0;
        break;
    }

    socket.writeAll(['\x1B', '-', value]);
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

    socket.writeAll(['\x1B', 'a', value]);
  }

  void resetToDefault() {
    setInverse(false);
    setBold(false);
    setUnderline(NetworkPOSPrinterUnderline.none);
    setJustification(NetworkPOSPrinterJustification.left);
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
