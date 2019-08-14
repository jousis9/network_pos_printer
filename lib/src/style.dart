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
  final bool bold;
  final bool inverse;
  final NetworkPOSPrinterUnderline underline;
  final NetworkPOSPrinterJustification justification;
  final NetworkPOSPrinterTextSize height;
  final NetworkPOSPrinterTextSize width;
  final NetworkPOSPrinterFont font;

  const NetworkPOSPrinterStyle({
    this.bold = false,
    this.inverse = false,
    this.underline = NetworkPOSPrinterUnderline.none,
    this.justification = NetworkPOSPrinterJustification.left,
    this.height = NetworkPOSPrinterTextSize.size1,
    this.width = NetworkPOSPrinterTextSize.size1,
    this.font = NetworkPOSPrinterFont.fontA,
  });
}
