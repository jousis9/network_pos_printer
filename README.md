# network_pos_printer

A wrapper to send texts (with simple styles like underline, bold, justification, etc.) to a network POS Printer.

Here an example on how to send texts and cut the ticket:
```
    NetworkPrinter.connect('192.168.81.81', 9100).then((printer) {
      for (int i = 1; i <= 10; i++) {
        printer.setBold(i % 2 == 0);
        printer.setInverse(i % 2 == 0);
        printer.setUnderline(i % 2 == 0 ? NetworkPrintUnderline.none : NetworkPrintUnderline.singleweight);
        printer.setJustification(i % 2 == 0 ? NetworkPrintJustification.left : NetworkPrintJustification.center);
        printer.writeLine('test $i');
      }

      // space blanks before cut
      for (int i = 0; i <= 5; i++) {
        printer.writeLine();
      }

      printer.cut();

      printer.close().then((v) {
        printer.destroy();
      });
    }).catchError((error) {
      print('error : ${error}');
    });
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.io/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
