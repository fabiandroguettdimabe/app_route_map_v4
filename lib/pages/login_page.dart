import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[background(context), formLogin(context)],
      ),
    );
  }

  Widget formLogin(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.40,
      width: size.width * 0.5,
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
                'Login',
              )),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Username', prefixIcon: Icon(Icons.person)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Contraseña', prefixIcon: Icon(Icons.lock)),
              ),
            ),
            Center(
              child: GFButton(
                  onPressed: () {
                    _showToast(context);
                  },
                  child: const Text('Login')),
            )
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
          child: GetCircle(0.1),
        ),
        Positioned(
          top: -40.0,
          right: -30,
          child: GetCircle(0.5),
        ),
        Positioned(
          bottom: -50,
          right: -10,
          child: GetCircle(0.05),
        ),
        Positioned(
          bottom: 120,
          right: 20,
          child: GetCircle(0.15),
        ),
        Positioned(
          bottom: -50,
          left: -20,
          child: GetCircle(0.25),
        ),
        Container(
          padding: const EdgeInsets.only(top: 100, bottom: 100),
          child: Column(children: const [
            GFAvatar(
              shape: GFAvatarShape.circle,
              child: Image(
                image: AssetImage('assets/img/logo.png'),
                width: 250,
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

  Widget GetCircle(double opacity) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, opacity),
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: const Text('Test'),
      action: SnackBarAction(
          label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ));
  }
}
