import 'dart:io';
import 'package:remont_kz/domain/entities/upload_image.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'file_api.g.dart';

@RestApi(baseUrl: "https://api.hitba.io")
abstract class FileApi {
  factory FileApi(Dio dio, {String baseUrl}) = _FileApi;
  @POST('/fs/static')
  @MultiPart()
  Future<UploadImage> uploadImage(
    @Part() File file,
    @Part() String dir,
  );
}
