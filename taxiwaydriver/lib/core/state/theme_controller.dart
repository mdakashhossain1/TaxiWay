import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeState {
  final bool isDark;
  final bool loading;

  const ThemeState({this.isDark = false, this.loading = true});
}

class ThemeController extends Notifier<ThemeState> {
  static const _key = 'app_theme_is_dark';
  final _storage = const FlutterSecureStorage();

  @override
  ThemeState build() {
    _load();
    return const ThemeState();
  }

  Future<void> _load() async {
    final raw = await _storage.read(key: _key);
    state = ThemeState(isDark: raw == 'true', loading: false);
  }

  Future<void> setDark(bool isDark) async {
    await _storage.write(key: _key, value: isDark.toString());
    state = ThemeState(isDark: isDark, loading: false);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeState>(
  ThemeController.new,
);
