import 'package:http_actions_example/commonModels/base_response.dart';

class LoginResponse extends BaseResponse {
  String? name;
  String? token;
  String? email;
  String? sId;
  String? bio;
  String? profilePic;
  String? profilePicThumbnail;

  LoginResponse(
      {this.name,
      this.token,
      this.email,
      this.sId,
      this.bio,
      this.profilePic,
      this.profilePicThumbnail});

  LoginResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json['data']['name'];
    token = json['data']['token'];
    email = json['data']['email'];
    sId = json['data']['_id'];
    bio = json['data']['bio'];
    profilePic = json['data']['profile_pic'];
    profilePicThumbnail = json['data']['profile_pic_thumbnail'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['token'] = token;
    data['email'] = email;
    data['_id'] = sId;
    data['bio'] = bio;
    data['profile_pic'] = profilePic;
    data['profile_pic_thumbnail'] = profilePicThumbnail;
    return data;
  }
}
