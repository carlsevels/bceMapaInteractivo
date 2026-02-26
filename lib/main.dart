import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mapa_interactivo/l10n/app_localizations.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  var initialRoute = await Routes.initialRoute;
  setUrlStrategy(PathUrlStrategy());
  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}
