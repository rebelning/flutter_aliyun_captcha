// https://help.aliyun.com/document_detail/121898.html

class AliyunCaptchaOption {
  String? sceneId;
  String? prefix;
  // // String? language;
  // // int? fontSize;
  // // bool? hideErrorCode;
  // Map<String, dynamic>? upLang;
  // dynamic? test;

  AliyunCaptchaOption({
    this.sceneId,
    this.prefix,
    // this.language,
    // this.fontSize,
    // this.hideErrorCode,
    // this.upLang,
    // this.test,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonObject = Map<String, dynamic>();
    if (sceneId != null) jsonObject.putIfAbsent("sceneId", () => sceneId);
    if (prefix != null) jsonObject.putIfAbsent("prefix", () => prefix);
    // if (language != null) jsonObject.putIfAbsent("language", () => language);
    // if (fontSize != null) jsonObject.putIfAbsent("fontSize", () => fontSize);
    // if (hideErrorCode != null)
    //   jsonObject.putIfAbsent("hideErrorCode", () => hideErrorCode);
    // if (upLang != null) jsonObject.putIfAbsent("upLang", () => upLang);
    // if (test != null) jsonObject.putIfAbsent("test", () => test);

    return jsonObject;
  }
}
