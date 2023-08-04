import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


abstract class LogoutPageRepository {}

class LogoutRepository extends LogoutPageRepository {
  @override
  Future<SharedPreferences> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    var url = Uri.parse('https://kangsayur.nitipaja.online/api/auth/logout');
    var response = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });


    print(response.statusCode);

    if (response.statusCode == 200) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('token');
      pref.clear();
      return pref;
    } else {
      throw Exception('Gagal Login');
    }
  }
}