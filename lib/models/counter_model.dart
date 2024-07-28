class CounterResponse {
  bool result;
  String message;
  CounterData data;

  CounterResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory CounterResponse.fromJson(Map<String, dynamic> json) {
    return CounterResponse(
      result: json['result'],
      message: json['message'],
      data: CounterData.fromJson(json['data']),
    );
  }
}

class CounterData {
  String counterCode;
  String invoice;
  int vendorId;
  String totalPrice;

  CounterData({
    required this.counterCode,
    required this.invoice,
    required this.vendorId,
    required this.totalPrice,
  });

  factory CounterData.fromJson(Map<String, dynamic> json) {
    return CounterData(
      counterCode: json['counter_code'],
      invoice: json['invoice'],
      vendorId: json['vendor_id'],
      totalPrice: json['total_price'],
    );
  }
}
