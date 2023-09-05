

import 'package:remont_kz/domain/entities/chat_response.dart';
import 'package:remont_kz/domain/entities/msg_response.dart';
import 'package:remont_kz/domain/entities/user.dart';

abstract class ChatRepo {
  Future<ChatResponse> getChats(String userParamId);

  Future<MsgResponse> getMsg(int id);

  Future<List<User>> getRecommendations(int pageSize);

  Future<void> userLike(int userId, bool isLike);
}
