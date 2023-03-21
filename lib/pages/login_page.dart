import 'package:app_route_map/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  Color blue = const Color(0xff2651a4);
  Color yellow = const Color(0xffc0b726);
  Color red = const Color(0xffa02c2b);
  Color green = const Color(0xff09831a);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(context),
          Center(
            child: formLogin(context),
          )
        ],
      ),
    );
  }

  Widget formLogin(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      height: size.width * 0.80,
      child: Card(
        semanticContainer: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(20),
        elevation: 15,
        child: Column(
          children: <Widget>[
            const ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Center(
                  child: Text(
                'Ingrese credenciales de acceso',
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    hintText: 'Nombre de Usuario',
                    prefixIcon: Icon(Icons.person)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Contraseña', prefixIcon: Icon(Icons.lock)),
              ),
            ),
            Center(
              child: GFButton(
                onPressed: () {
                  AuthService()
                      .login(usernameController.text, passwordController.text)
                      .then((value) => {
                            if (value['login'])
                              {
                                _showToast(context, value['message']),
                                Navigator.pushNamed(context, '/')
                              }
                            else
                              {_showToast(context, value['message'])}
                          });
                },
                color: green,
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget background(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Color(0xff1f418b), Color(0xff1c5eed)])),
    );
    return Stack(
      children: <Widget>[
        backgroundColor,
        Positioned(
          top: 90,
          left: 30,
          child: getCircle(0.1),
        ),
        Positioned(
          top: -40.0,
          right: -30,
          child: getCircle(0.5),
        ),
        Positioned(
          bottom: -50,
          right: -4,
          child: getCircle(0.05),
        ),
        Positioned(
          bottom: 120,
          right: 20,
          child: getCircle(0.15),
        ),
        Positioned(
          bottom: -50,
          left: -20,
          child: getCircle(0.25),
        ),
        Container(
          padding: const EdgeInsets.only(top: 100, bottom: 100),
          child: Column(children: const [
            GFAvatar(
              shape: GFAvatarShape.circle,
              child: Image(
                image: AssetImage('assets/img/logo.png'),
                width: 300,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
            )
          ]),
        )
      ],
    );
  }

  Widget getCircle(double opacity) {
    return SizedBox(
      height: 340,
      width: 110,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color.fromRGBO(255, 255, 255, opacity),
        ),
      ),
    );
  }
}

void _showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(
    content: Text(message),
    action:
        SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  ));
}
