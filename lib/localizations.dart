import 'package:flutter/widgets.dart';

class FlutterMapWrapperLocalizations {
  const FlutterMapWrapperLocalizations({
    this.chooseMapType = "Choose Map Type",
  });

  final String chooseMapType;
}

class FlutterMapWrapperLocalizationsInherited extends InheritedWidget {
  const FlutterMapWrapperLocalizationsInherited({
    super.key,
    required super.child,
    required this.localizations,
  });

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
