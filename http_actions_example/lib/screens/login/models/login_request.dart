class LoginRequest {
  String? email;
  String? password;
  String? token;

  LoginRequest({this.email, this.password, this.token});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['token'] = token;
    return data;
  }
}
