import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Supported app languages. Order here drives the order shown in pickers.
const List<Locale> kSupportedLocales = [Locale('en'), Locale('hi'), Locale('bn')];

class LocaleState {
  /// Null while still reading from storage, or once storage has confirmed
  /// no language has ever been chosen (first launch).
  final Locale? locale;
  final bool loading;

  const LocaleState({this.locale, this.loading = true});

  bool get hasChosen => !loading && locale != null;
}

class LocaleController extends Notifier<LocaleState> {
  static const _key = 'app_locale_code';
  final _storage = const FlutterSecureStorage();

  @override
  LocaleState build() {
    _load();
    return const LocaleState();
  }

  Future<void> _load() async {
    final code = await _storage.read(key: _key);
    state = LocaleState(locale: code != null ? Locale(code) : null, loading: false);
  }

  Future<void> setLocale(Locale locale) async {
    await _storage.write(key: _key, value: locale.languageCode);
    state = LocaleState(locale: locale, loading: false);
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, LocaleState>(
  LocaleController.new,
);
