

import 'package:remont_kz/data/api_builder.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/entities/chat_response.dart';
import 'package:remont_kz/domain/entities/msg_response.dart';
import 'package:remont_kz/domain/entities/user.dart';
import 'package:remont_kz/domain/repositories/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final _api = getIt.get<ApiBuilder>().getChatApi();

  @override
  Future<ChatResponse> getChats(String userParamId) async {
    return await _api.getChats(
        'page_size=20&with_boy=true&with_girl=true&with_uali=true&with_total_count=true&$userParamId');
  }

  @override
  Future<MsgResponse> getMsg(int id) async {
    return await _api.getMsg(id, '?page_size=200');
  }

  @override
  Future<List<User>> getRecommendations(int pageSize) async {
    return await _api.getRecommendations(pageSize);
  }

  @override
  Future<void> userLike(int userId, bool isLike) async {
    await _api.userLike({"action": isLike ? 1 : 2, "op_usr_id": userId});
  }
}
