
import 'package:localization/localization.dart';
import 'package:styles/styles.dart';

import '../../config/env.dart';
import '../application/theme/theme_impl.dart';
import 'models/app_storage.dart';

final class Initialization {
  final Env env;
  Initialization(this.env);

  Future<AppStorage> initialize() async {
    ThemeCubit themeCubit = await _initThemeCubit();

    LocalizationBase localization = await _initLocalization();
    return AppStorage(
      themeCubit: themeCubit,
      // errorTrackingManager: errorTrackingManager,
      localization: localization,
    );
  }


  Future<ThemeCubit> _initThemeCubit() async {
    ///TODO:: handle initial/saved theme mode;

    ThemeImpl theme = ThemeImpl();
    final ThemeState initialState = ThemeIdleState(theme);
    ThemeCubit themeCubit = ThemeCubit(initialState);

    return themeCubit;
  }

  Future<LocalizationBase> _initLocalization() async {
    //TODO:: handle initial/saved locale
    String initialLanguageCode = "en";
    LocalizationBase localization = SlangLocalizationImpl(initialLanguageCode);

    return localization;
  }
}
