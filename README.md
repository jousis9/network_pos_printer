# network_pos_printer

<div align="center"><p>A dart/flutter package to send texts silently (with simple styles like underline, bold, justification, etc.) to a network ESC/POS printer.</p></div><br>

<div align="center">
	<a href="https://flutter.io">
        <img src="https://img.shields.io/badge/Platform-Flutter-yellow.svg" alt="Platform" />
    </a>
  
   [![Pub Package](https://img.shields.io/pub/v/network_pos_printer.svg)](https://pub.dev/packages/network_pos_printer)
</div>
<br />


It lets you send the data to the printer without previewing a document (usually thermal printers), with the ESC/POS script.

Here an example on how to send texts and cut the ticket:
```
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
```

Some printers will not accept NetworkPOSPrinterUnderline.double, only a single weight will be printed.

## TODO

* method documentation

## Support
If this package was helpful to you in delivering on your project or you just wanna to support this project, a cup of tea would be highly appreciated ;-)

[![Buy me a tea](https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png)](https://buymeacoff.ee/benverstraete)