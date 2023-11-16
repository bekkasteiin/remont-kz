
import 'package:flutter/cupertino.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/entities/token_model.dart';
import 'package:remont_kz/domain/services/token_store_interface.dart';

import 'package:shared_preferences/shared_preferences.dart';

const storageTokenKey = 'ACCESS_TOKEN_STORAGE';

class TokenStoreService implements TokenStoreInterface {
  TokenStoreService();

  SharedPreferences? tokenStorage;
  var storage = const TokenModel();
  Locale locale = Locale('en', 'US');

  initialize(SharedPreferences storage) {
    tokenStorage = storage;
    getToken();
  }

  @override
  get accessToken => storage.accessToken;

  @override
  get refreshToken => storage.refreshToken;

  @override
  get tokenValid => storage.accessToken != null && storage.refreshToken != null;

  @override
  void getToken() async {
    final tokenString = tokenStorage?.getString(storageTokenKey);
    if (tokenString != null) {
      storage = TokenModel.deserialize(tokenString);
    }
    final lang = tokenStorage?.getString('lang');
    if (lang != null) {
      locale = Locale(lang);
    }
  }

  @override
  Future<void> setLang(Locale l) async {
    await tokenStorage?.setString('lang', l.languageCode);
    locale = l;
  }

  @override
  Future<void> saveToken(TokenModel tokenModel) async {
    await tokenStorage?.setString(storageTokenKey, tokenModel.serialize());
    storage = tokenModel;
  }

  @override
  Future<void> updateToken(TokenModel tokenModel) async {
    try {
      // final authRepository = getIt<MgoAuthRepository>();
      // await authRepository.refreshSession();
    } catch (error) {
      storage = const TokenModel();
    }
  }

  @override
  Future<void> clearAndLogoutToken() async {
    await tokenStorage?.clear();
    await tokenStorage?.remove(storageTokenKey);
    storage = const TokenModel();
  }
}
