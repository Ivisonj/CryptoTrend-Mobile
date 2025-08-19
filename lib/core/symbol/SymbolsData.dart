enum TimeframeStatus {
  bullish("Bullish"),
  bearish("Bearish"),
  neutral("-");

  const TimeframeStatus(this.value);
  final String value;
}

class Timeframes {
  final TimeframeStatus fifteenMinutes;
  final TimeframeStatus oneHour;
  final TimeframeStatus fourHours;
  final TimeframeStatus daily;
  final TimeframeStatus weekly;

  Timeframes({
    required this.fifteenMinutes,
    required this.oneHour,
    required this.fourHours,
    required this.daily,
    required this.weekly,
  });
}

class SymbolData {
  final String symbol;
  final double price;
  final Timeframes timeframes;

  SymbolData({
    required this.symbol,
    required this.price,
    required this.timeframes,
  });
}
