import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinksServices {
  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen(
        (PendingDynamicLinkData dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        if (deepLink.pathSegments.contains('token')) {
          print(deepLink.path);
          // Navigator.push(context, );
        }
      }
    }, onError: (error, stacktrace) {
      print("error : $error => $stacktrace");
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.pathSegments.contains('token')) {
        print(deepLink.path);
        // Navigator.pushNamed(context, deepLink.path);
      }
    }
  }

  Future<String> getQrCodeDynamicLink(String? token) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://ptsapp.page.link',
      link: Uri.parse(
          ''),
      androidParameters: AndroidParameters(
        packageName: 'pts-beta-yog',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.yog.pts',
      ),
    );
    final Uri shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    return shortDynamicLink.toString();
  }
}
