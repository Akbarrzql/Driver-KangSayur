import 'package:driver_kangsayur/ui/auth/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class LoginPageRepository {
  Future<LoginModel> login(String email, String password);
}

class LoginRepository implements LoginPageRepository {
  @override
  Future<LoginModel> login(String email, String password) async {
    var url = Uri.parse('https://kangsayur.nitipaja.online/api/auth/login');
    var response = await http.post(url,
        headers: {
          'Accept': 'application/json',
        },body: {
          'email': email,
          'password': password,
        });

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      LoginModel login = loginModelFromJson(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', login.accesToken);
      return login;
    } else {
      throw Exception('Gagal Login');
    }
  }
}