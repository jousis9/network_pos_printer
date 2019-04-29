# network_pos_printer

[![Pub Package](https://img.shields.io/pub/v/network_pos_printer.svg?style=flat-square)](https://pub.dartlang.org/packages/network_pos_printer)

A dart/flutter package to send texts silently (with simple styles like underline, bold, justification, etc.) to a network POS printer.

It lets you send the data to the printer without previewing a document (it is usually used as a receipt print).

Here an example on how to send texts and cut the ticket:
```
    NetworkPOSPrinter.connect('192.168.81.80', 9100).then((printer) {

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
```

Some printers will not accept NetworkPOSPrinterUnderline.double, only a single weight will be printed.

TODO: method documentation
