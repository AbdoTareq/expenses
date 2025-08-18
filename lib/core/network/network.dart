import 'package:dio/dio.dart';
import 'package:expenses/core/error/exceptions.dart';
import 'package:expenses/core/network/endpoints.dart';

abstract class NetworkInterface {
  Future<Response> get(String endPoint);
}

class Network implements NetworkInterface {
  final Dio dio;
  Network({required this.dio});

  late Map<String, String?> headers;

  Future<Response> _req(Future<Response> Function() requestType) async {
    headers = {'Content-Type': 'application/json'};
    try {
      final response = await requestType();
      if (response.statusCode! > 210 || response.statusCode! < 200) {
        // Logger().i(response.data);
        throw response.data;
      }
      // success
      return response;
    } on DioException catch (e) {
      // Logger().i(e.message);
      throw ServerException(message: e.message);
    } catch (e) {
      // Logger().i(e);
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Response> get(String endPoint) {
    return _req(() {
      return dio.get(
        Endpoints.baseUrl + endPoint,
        options: Options(headers: headers),
      );
    });
  }
}
