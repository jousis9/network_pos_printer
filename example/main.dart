import 'package:network_pos_printer/network_pos_printer.dart';

main(List<String> arguments) {
  NetworkPOSPrinter.connect('192.168.81.80', 9100).then((printer) {

    printer.setBold(true);
    printer.writeLine('Test bold');

    printer.resetToDefault();

    printer.setInverse(true);
    printer.writeLine('Test inverse');

    printer.resetToDefault();

    printer.setUnderline(NetworkPOSPrinterUnderline.single_weight);
    printer.writeLine('Test underline');

    printer.resetToDefault();

    printer.setJustification(NetworkPOSPrinterJustification.center);
    printer.writeLine('Test justification');

    // space blanks before cut
    for (int i = 0; i <= 5; i++) {
      printer.writeLine();
    }

    printer.cut();

    printer.close().then((v) {
      printer.destroy();
    });
  }).catchError((error) {
    print('error : $error');
  });
}