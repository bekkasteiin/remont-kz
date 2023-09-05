

import 'package:flutter/cupertino.dart';
import 'package:remont_kz/domain/entities/token_model.dart';

abstract class TokenStoreInterface {
  void getToken();
  Future<void> saveToken(TokenModel tokenModel);
  Future<void> updateToken(TokenModel tokenModel);
  Future<void> clearAndLogoutToken();
  get accessToken;
  get refreshToken;
  get tokenValid;

  Future<void> setLang(Locale locale);
}
