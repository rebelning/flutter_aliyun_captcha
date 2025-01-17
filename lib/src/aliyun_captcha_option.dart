// https://help.aliyun.com/document_detail/121898.html

class AliyunCaptchaOption {
  String? sceneId;
  String? prefix;
  int? timeout;
  int? width;
  int? height;
  // // String? language;
  // // int? fontSize;
  // // bool? hideErrorCode;
  // Map<String, dynamic>? upLang;
  // dynamic? test;

  AliyunCaptchaOption({
    this.sceneId,
    this.prefix,
    this.timeout,
    this.width,
    this.height,
    // this.language,
    // this.fontSize,
    // this.hideErrorCode,
    // this.upLang,
    // this.test,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    if (sceneId != null) json.putIfAbsent("sceneId", () => sceneId);
    if (prefix != null) json.putIfAbsent("prefix", () => prefix);
    if (timeout != null) json.putIfAbsent("timeout", () => timeout);
    if (width != null) json.putIfAbsent("width", () => width);
    if (height != null) json.putIfAbsent("height", () => height);
    // if (language != null) jsonObject.putIfAbsent("language", () => language);
    // if (fontSize != null) jsonObject.putIfAbsent("fontSize", () => fontSize);
    // if (hideErrorCode != null)
    //   jsonObject.putIfAbsent("hideErrorCode", () => hideErrorCode);
    // if (upLang != null) jsonObject.putIfAbsent("upLang", () => upLang);
    // if (test != null) jsonObject.putIfAbsent("test", () => test);

    return json;
  }
}
