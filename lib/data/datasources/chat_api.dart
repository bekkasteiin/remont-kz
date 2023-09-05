import 'package:dependencies/dependencies.dart';
import 'package:remont_kz/domain/entities/chat_response.dart';
import 'package:remont_kz/domain/entities/msg_response.dart';
import 'package:remont_kz/domain/entities/user.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_api.g.dart';

@RestApi(baseUrl: "https://api.hitba.io/main")
abstract class ChatApi {
  factory ChatApi(Dio dio, {String baseUrl}) = _ChatApi;

  @GET('/profile/chat?{params}')
  Future<ChatResponse> getChats(@Path() String params);

  @GET('/profile/chat/{id}/{params}')
  Future<MsgResponse> getMsg(@Path() int id, @Path() String params);

  @GET('/profile/recommendations')
  Future<List<User>> getRecommendations(@Query("page_size") int pageSize);

  @POST('/usr_like')
  Future<void> userLike(@Body() Map<String, dynamic> map);
}
