import 'package:network_pos_printer/network_pos_printer.dart';

main(List<String> arguments) {
  NetworkPOSPrinter.connect('192.168.81.80', 9100).then((printer) {
    printer.writeLineWithStyle('Test with style'.toUpperCase(),
        style: NetworkPOSPrinterStyle(
          justification: NetworkPOSPrinterJustification.center,
          width: NetworkPOSPrinterTextSize.size2,
          height: NetworkPOSPrinterTextSize.size2,
          font: NetworkPOSPrinterFont.fontB,
        ),
        linesAfter: 1);

    // total width of columns must be equal to 12
    printer.writeRow(<NetworkPOSColumn>[
      NetworkPOSColumn(
        text: 'left align',
        width: 6,
        style: NetworkPOSPrinterStyle(
            bold: true, justification: NetworkPOSPrinterJustification.left),
      ),
      NetworkPOSColumn(
        text: 'right align',
        width: 6,
        style: NetworkPOSPrinterStyle(
            bold: true, justification: NetworkPOSPrinterJustification.right),
      ),
    ]);

    printer.setBold(true);
    printer.writeLine('Test bold');

    printer.resetToDefault();

    printer.setInverse(true);
    printer.writeLine('Test inverse');

    printer.resetToDefault();

    printer.setUnderline(NetworkPOSPrinterUnderline.single);
    printer.writeLine('Test underline');

    printer.resetToDefault();

    printer.setJustification(NetworkPOSPrinterJustification.center);
    printer.writeLine('Test justification');

    printer.resetToDefault();

    printer.setFont(NetworkPOSPrinterFont.fontB);
    printer.writeLine('Test font');

    // space blanks before cut
    printer.writeLines(List.filled(5, ''));

    printer.cut();

    printer.close().then((v) {
      printer.destroy();
    });
  }).catchError((error) {
    print('error : $error');
  });
}
