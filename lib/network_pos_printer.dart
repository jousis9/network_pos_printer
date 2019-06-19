library network_pos_printer;

import 'dart:io';
import 'dart:typed_data';

enum NetworkPOSPrinterUnderline { none, single, double }
enum NetworkPOSPrinterJustification { left, center, right }
enum NetworkPOSPrinterFont { fontA, fontB }

class NetworkPOSPrinterTextSize {
  const NetworkPOSPrinterTextSize._internal(this.value);

  final int value;
  static const size1 = NetworkPOSPrinterTextSize._internal(1);
  static const size2 = NetworkPOSPrinterTextSize._internal(2);
  static const size3 = NetworkPOSPrinterTextSize._internal(3);
  static const size4 = NetworkPOSPrinterTextSize._internal(4);
  static const size5 = NetworkPOSPrinterTextSize._internal(5);
  static const size6 = NetworkPOSPrinterTextSize._internal(6);
  static const size7 = NetworkPOSPrinterTextSize._internal(7);
  static const size8 = NetworkPOSPrinterTextSize._internal(8);

  static int getSize(
          NetworkPOSPrinterTextSize width, NetworkPOSPrinterTextSize height) =>
      16 * (width.value - 1) + (height.value - 1);
}

class NetworkPOSPrinterStyle {
  const NetworkPOSPrinterStyle({
    this.bold = false,
    this.inverse = false,
    this.underline = NetworkPOSPrinterUnderline.none,
    this.justification = NetworkPOSPrinterJustification.left,
    this.height = NetworkPOSPrinterTextSize.size1,
    this.width = NetworkPOSPrinterTextSize.size1,
    this.font = NetworkPOSPrinterFont.fontA,
  });

  final bool bold;
  final bool inverse;
  final NetworkPOSPrinterUnderline underline;
  final NetworkPOSPrinterJustification justification;
  final NetworkPOSPrinterTextSize height;
  final NetworkPOSPrinterTextSize width;
  final NetworkPOSPrinterFont font;
}

const String _esc = '\x1B';
const String _gs = '\x1D';
const String _gsNot = '$_gs!';

class NetworkPOSPrinter {
  Socket socket;

  NetworkPOSPrinter({this.socket});

  static Future<NetworkPOSPrinter> connect(host, int port,
      {sourceAddress, Duration timeout}) {
    return Socket.connect(host, port,
            sourceAddress: sourceAddress, timeout: timeout)
        .then((socket) {
      return NetworkPOSPrinter(socket: socket);
    });
  }

  writeLineWithStyle(Object obj,
      {NetworkPOSPrinterStyle style = const NetworkPOSPrinterStyle(),
      int linesAfter = 0}) {
    setBold(style.bold);
    setJustification(style.justification);
    setUnderline(style.underline);
    setInverse(style.inverse);
    setTextSize(style.width, style.height);
    setFont(style.font);

    writeLine(obj);

    if (linesAfter > 0) {
      writeLines(List.filled(linesAfter, ''));
    }

    resetToDefault();
  }

  void writeAll(Iterable objects, [String separator = '']) {
    socket.writeAll(objects, separator);
  }

  writeLine(Object obj) {
    socket.writeln(obj);
  }

  void write(Object obj) {
    socket.write(obj);
  }

  void writeLines(Iterable objects) {
    for (var o in objects) {
      writeLine(o);
    }
  }

  void cut() {
    write('${_esc.toString()}@${_gs}V1');
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

  void setTextSize(
      NetworkPOSPrinterTextSize width, NetworkPOSPrinterTextSize height) {
    socket.add(Uint8List.fromList(List.from(_gsNot.codeUnits)
      ..add(NetworkPOSPrinterTextSize.getSize(width, height))));
  }

  setFont(NetworkPOSPrinterFont font) {
    writeAll([_esc, font == NetworkPOSPrinterFont.fontA ? 'M0' : 'M1']);
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
