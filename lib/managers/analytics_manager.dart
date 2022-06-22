import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pts/services/auth_service.dart';
import 'package:pts/services/user_service.dart';

abstract class AnalyticsInterface {
  Future<void> init();
  void logEvent(String name, {Map<String, String>? params});
}

class FirebaseAnalyticsImplementation extends AnalyticsInterface {
  final UserService userService = UserService();
  final AuthService authService = AuthService();

  @override
  void logEvent(String name, {Map<String, String>? params}) {
    FirebaseAnalytics.instance.logEvent(name: name, parameters: params);
  }

  @override
  Future<void> init() async {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    var id = await authService.getToken();
    if (id == null) return;
    var user = await userService.getUser(id);

    if (user.analyticsId == null) return;

    analytics.setUserId(id: user.analyticsId);
    analytics.setUserProperty(name: "age", value: user.age);
    analytics.setUserProperty(name: "gender", value: user.gender);
    analytics.setUserProperty(
        name: "verified", value: user.verified.toString());
  }
}

class AnalyticsManager extends InheritedWidget {
  final AnalyticsInterface analyticsInterface;

  const AnalyticsManager({
    Key? key,
    required Widget child,
    required this.analyticsInterface,
  }) : super(key: key, child: child);

  static AnalyticsManager of(BuildContext context) {
    final AnalyticsManager? result =
        context.dependOnInheritedWidgetOfExactType<AnalyticsManager>();
    assert(result != null, 'No AnalyticsManager found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AnalyticsManager old) {
    return false;
  }

  Future<void> init() async {
    await analyticsInterface.init();
  }

  void logEvent(String name, {Map<String, String>? params}) {
    analyticsInterface.logEvent(name, params: params);
  }
}
