class LoginResponse {
  String? accessToken;
  String? refreshTokenToken;

  LoginResponse({this.accessToken, this.refreshTokenToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshTokenToken = json['refreshTokenToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshTokenToken'] = this.refreshTokenToken;
    return data;
  }
}