import 'package:get/get.dart';
import 'package:repo/core/routes/routes.dart';

class ApiService extends GetConnect implements GetxService {
  Future<Response> login(String uri, dynamic body) async {
    Response response = await post(
      ApiRoutesRepo.baseUrl + uri,
      body,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    return response;
  }
}