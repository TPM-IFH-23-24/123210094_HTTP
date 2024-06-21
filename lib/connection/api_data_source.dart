import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();
  static Future<Map<String, dynamic>> loadUsers(int index) async {
    return BaseNetwork.get("users?page=$index");
  }

  static Future<Map<String, dynamic>> userDetails(int id) async {
    return BaseNetwork.get("users/$id");
  }
}