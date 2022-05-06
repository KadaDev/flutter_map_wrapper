import 'package:flutter/widgets.dart';

class FlutterMapWrapperLocalizations {
  const FlutterMapWrapperLocalizations({
    this.chooseMapType = "Choose Map Type",
  });

  final String chooseMapType;
}

class FlutterMapWrapperLocalizationsInherited extends InheritedWidget {
  const FlutterMapWrapperLocalizationsInherited({
    Key? key,
    required Widget child,
    required this.localizations,
  }) : super(
          key: key,
          child: child,
        );

  final FlutterMapWrapperLocalizations localizations;

  @override
  bool updateShouldNotify(
    covariant FlutterMapWrapperLocalizationsInherited oldWidget,
  ) =>
      oldWidget.localizations != localizations;
}

extension LocalizationsExtension on BuildContext {
  FlutterMapWrapperLocalizations get localizations {
    final widget = getElementForInheritedWidgetOfExactType<
            FlutterMapWrapperLocalizationsInherited>()!
        .widget as FlutterMapWrapperLocalizationsInherited;
    return widget.localizations;
  }
}
