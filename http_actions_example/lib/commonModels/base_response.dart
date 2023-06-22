class BaseResponse {
  int? code;
  String? status;
  String? message;

  BaseResponse({this.code, this.status});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    return data;
  }
}
