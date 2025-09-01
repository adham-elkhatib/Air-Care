class AppInfo {
  //
  //t2 Developer
  static const String developerName = "micazi";
  static const String developerSite = "micazi.dev";
  static const String developerContact = "michael@micazi.dev";

  //
  //t2 Org/Client
  static const String orgSite = "2mastravels.com";

  //
  //t2 App
  static const String appTitle = "Tomas Travels: Client";
  static const String appTagline = "";
  static String appName = appTitle.toLowerCase().replaceAll(' ', '_');
  static String appId =
      "${orgSite.split('.')[1]}.${orgSite.split('.')[0]}.$appName";

  //
  static const num versionMajor = 0;
  static const num versionMinor = 0;
  static const num versionFeature = 0;
  static const num versionBuild = 1;
  static const String versionFlag = "alpha";

  //
  static const String versionPrint =
      "V$versionMajor.$versionMinor.$versionFeature+$versionBuild${versionFlag != '' ? '-$versionFlag' : ''}";
}
