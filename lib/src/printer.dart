import 'dart:io';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:network_pos_printer/src/command.dart';
import 'package:network_pos_printer/src/style.dart';

import 'column.dart';

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
    write(Command.cut);
  }

  void feed(int feed) {
    writeAll([Command.feed, feed]);
  }

  Future<dynamic> flush() {
    return socket.flush();
  }

  Future<dynamic> close() {
    return socket.close();
  }

  void setBold(bool bold) {
    write(bold ? Command.boldOn : Command.boldOff);
  }

  void setInverse(bool inverse) {
    write(inverse ? Command.inverseOn : Command.inverseOff);
  }

  void setTextSize(
      NetworkPOSPrinterTextSize width, NetworkPOSPrinterTextSize height) {
    socket.add(Uint8List.fromList(List.from(Command.gsNot.codeUnits)
      ..add(NetworkPOSPrinterTextSize.getSize(width, height))));
  }

  setFont(NetworkPOSPrinterFont font) {
    write(font == NetworkPOSPrinterFont.fontA ? Command.fontA : Command.fontB);
  }

  void setUnderline(NetworkPOSPrinterUnderline underline) {
    String command;

    switch (underline) {
      case NetworkPOSPrinterUnderline.none:
        command = Command.underlineNone;
        break;

      case NetworkPOSPrinterUnderline.single:
        command = Command.underlineSingle;
        break;

      case NetworkPOSPrinterUnderline.double:
        command = Command.underlineDouble;
        break;

      default:
        command = Command.underlineNone;
        break;
    }

    write(command);
  }

  void setJustification(NetworkPOSPrinterJustification justification) {
    String command;

    switch (justification) {
      case NetworkPOSPrinterJustification.left:
        command = Command.alignLeft;
        break;

      case NetworkPOSPrinterJustification.center:
        command = Command.alignCenter;
        break;

      case NetworkPOSPrinterJustification.right:
        command = Command.alignRight;
        break;

      default:
        command = Command.alignLeft;
        break;
    }

    write(command);
  }

  void resetToDefault() {
    write(Command.reset);
  }

//  void beep() {
//    socket.writeAll(['\x1B', '(A', 4, 0, 48, 55, 3, 15]);
//  }

//  void setLineSpacing(int spacing) {
//    socket.writeAll(['\x1B', '3', spacing]);
//  }

  // writeRow
  writeRow(List<NetworkPOSColumn> columns) {
    int sum = 0;

    columns.forEach((c) => sum += c.width);

    if (sum != 12) throw Exception('Total columns width must be equal to 12');

    for (int i = 0; i < columns.length; ++i) {
      final int columnIndex =
          columns.sublist(0, i).fold(0, (int sum, c) => sum + c.width);

      NetworkPOSColumn column = columns[i];

      _writeColumn(
        text: column.text,
        style: column.style,
        columnIndex: columnIndex,
        columnWidth: column.width,
      );
    }

    writeLine('');

    resetToDefault();
  }

  double _columnIndexToPosition(int columnIndex) {
    return columnIndex == 0 ? 0 : (512 * columnIndex / 11 - 1);
  }

  _writeColumn({
    String text,
    NetworkPOSPrinterStyle style = const NetworkPOSPrinterStyle(),
    int columnIndex = 0,
    int columnWidth = 12,
  }) {
    const charLength = 11.625;
    double fromPosition = _columnIndexToPosition(columnIndex);

    // justification
    if (columnWidth == 12) {
      write(style.justification == NetworkPOSPrinterJustification.left
          ? Command.alignLeft
          : (style.justification == NetworkPOSPrinterJustification.center
              ? Command.alignCenter
              : Command.alignRight));
    } else {
      final double toPosition =
          _columnIndexToPosition(columnIndex + columnWidth) - 5;
      final double textLength = text.length * charLength;

      if (style.justification == NetworkPOSPrinterJustification.right) {
        fromPosition = toPosition - textLength;
      } else if (style.justification == NetworkPOSPrinterJustification.center) {
        fromPosition =
            fromPosition + (toPosition - fromPosition) / 2 - textLength / 2;
      }
    }

    final hexString = fromPosition.round().toRadixString(16).padLeft(3, '0');
    final hexPair = HEX.decode(hexString);

    setBold(style.bold);
    setUnderline(style.underline);
    setInverse(style.inverse);
    setFont(style.font);
    setTextSize(style.width, style.height);

    // position
    socket.add(Uint8List.fromList(List.from(Command.absolutePosition.codeUnits)
      ..addAll([hexPair[1], hexPair[0]])));

    write(text);
  }

  void destroy() {
    socket.destroy();
  }
}
