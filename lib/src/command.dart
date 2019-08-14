class Command {
  static String esc = '\x1B';
  static String gs = '\x1D';
  static String gsNot = '$gs!';
  static String escNot = '$esc!';
  static String fs = '\x1C';

  static String alignLeft = '${esc}a0';
  static String alignCenter = '${esc}a1';
  static String alignRight = '${esc}a2';

  static String absolutePosition = '$esc\$';

  static String boldOn = '${esc}E1';
  static String boldOff = '${esc}E0';

  static String inverseOn = '${gs}B1';
  static String inverseOff = '${gs}B0';

  static String underlineNone = '$esc-0';
  static String underlineSingle = '$esc-1';
  static String underlineDouble = '$esc-2';

  static String fontA = '${esc}M0';
  static String fontB = '${esc}M1';

  static String cut = '$esc@${gs}V1';

  static String feed = '${esc}d';

  static String reset = '$esc@';
}
