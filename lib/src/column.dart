import 'package:network_pos_printer/src/style.dart';

class NetworkPOSColumn {
  final String text;
  final int width;
  final NetworkPOSPrinterStyle style;

  NetworkPOSColumn({
    this.text = '',
    this.width = 2,
    this.style = const NetworkPOSPrinterStyle(),
  }) : assert(
            width >= 1 && width <= 12, 'Column width must be between 1 and 12');
}
