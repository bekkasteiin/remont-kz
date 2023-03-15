import '../../core.dart';
import '../exceptions/custom_exception.dart';

/// Base meta when receive data from a API
class MetaData {
  /// Total count data item
  final int? totalData;

  /// Message response server
  final String? message;

  /// Status code from server
  final int? statusCode;

  /// Current page
  final int? page;

  /// Item count in current page pagination
  final int? perPage;

  /// Total pages pagination
  final int? totalPage;

  ///
  MetaData({
    this.totalData,
    this.message,
    this.statusCode,
    this.page,
    this.perPage,
    this.totalPage,
  });

  /// Mapping data [MetaData] from Map or Json data
  factory MetaData.fromJson(Map<String, dynamic>? json) {
    try {
      final totalData = json?['total_data'];
      final message = json?['message'];
      final statusCode = Utils.intParser(json?['status_code']);
      final page = Utils.intParser(json?['page']);
      final perPage = Utils.intParser(json?['per_page']);
      final totalPage = Utils.intParser(json?['total_page']);

      return MetaData(
        totalData: totalData,
        message: message,
        statusCode: statusCode,
        page: page,
        perPage: perPage,
        totalPage: totalPage,
      );
    } on Exception catch (e) {
      throw ModelException('Unable to parse cart', e);
    }
  }

  /// Generate [MetaData] toMap
  Map<String, dynamic> toJson() {
    return {
      'total_data': totalData,
      'message': message,
      'status_code': statusCode,
      'page': page,
      'per_page': perPage,
      'total_page': totalPage,
    };
  }
}
