import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/configs/theme/snack_bar.dart';
import 'package:cardapio/controller/login_controller.dart';
import 'package:cardapio/view/navigation.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  bool _obscureText = true;
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String? _emailErrorMessage;
  String? _senhaErrorMessage;
  bool _isLoading = false;

  void _updateEmailError(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailErrorMessage = null;
      } else if (!value.contains('@') ||
          value.indexOf('@') == 0 ||
          value.lastIndexOf('@') == value.length - 1 ||
          !value.contains('.com', value.indexOf('@'))) {
        _emailErrorMessage = 'Por favor, insira um e-mail válido.';
      } else if (value.indexOf('@') < value.length - 1 &&
          value[value.indexOf('@') + 1] != '.') {
        _emailErrorMessage = null;
      } else {
        _emailErrorMessage = 'Por favor, insira um e-mail válido.';
      }
    });
  }

  void _updateSenhaError(String value) {
    setState(() {
      if (value.isEmpty) {
        _senhaErrorMessage = null;
      } else if (value.length < 6) {
        _senhaErrorMessage = 'A senha deve conter no mínimo 6 caracteres.';
      } else {
        _senhaErrorMessage = null;
      }
    });
  }

  Future<void> _realizarLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final String email = usuarioController.text;
    final String senha = senhaController.text;

    if (_emailErrorMessage != null || _senhaErrorMessage != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      CustomSnackBar.showDefault(
        context,
        'Por favor, corrija os campos destacados.',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      AuthService authService = AuthService();
      final User? user =
          await authService.signInWithEmailAndPassword(email, senha);

      if (user != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Navigation()),
          (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        CustomSnackBar.showDefault(
          context,
          'Login efetuado com sucesso!',
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        CustomSnackBar.showDefault(
          context,
          'E-mail ou Senha incorretos.',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao efetuar login: $e');
      }
      // Handle other errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: CustomColors.primaryGradient,
          ),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Entrar',
                style: TextStyle(
                  color: CustomColors.fontPrimaryColor,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: kIsWeb ? 500 : null,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.asset('images/sign_in.png'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: usuarioController,
                    onChanged: _updateEmailError,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: const TextStyle(
                        color: CustomColors.fontSecundaryColor,
                      ),
                      hintText: 'Ex: exemplo@gmail.com',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: CustomColors.secondaryColor,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.secondaryColor,
                        ),
                      ),
                      errorText: _emailErrorMessage,
                      errorStyle: const TextStyle(
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    style: const TextStyle(
                      color: CustomColors.fontSecundaryColor,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (_) {
                      if (_emailErrorMessage == null &&
                          _senhaErrorMessage == null &&
                          usuarioController.text.isNotEmpty &&
                          senhaController.text.isNotEmpty) {
                        _realizarLogin(context);
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: senhaController,
                    obscureText: _obscureText,
                    onChanged: _updateSenhaError,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: const TextStyle(
                        color: CustomColors.fontSecundaryColor,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: CustomColors.secondaryColor,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.secondaryColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: CustomColors.secondaryColor,
                        ),
                      ),
                      errorText: _senhaErrorMessage,
                      errorStyle: const TextStyle(
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    style: const TextStyle(
                      color: CustomColors.fontSecundaryColor,
                      fontSize: 18,
                    ),
                    onSubmitted: (_) {
                      if (_emailErrorMessage == null &&
                          _senhaErrorMessage == null &&
                          usuarioController.text.isNotEmpty &&
                          senhaController.text.isNotEmpty) {
                        _realizarLogin(context);
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: (_emailErrorMessage == null &&
                              _senhaErrorMessage == null &&
                              usuarioController.text.isNotEmpty &&
                              senhaController.text.isNotEmpty)
                          ? CustomColors.secondaryColor
                          : CustomColors.tertiaryColor,
                      padding: const EdgeInsets.all(25.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: (_emailErrorMessage == null &&
                            _senhaErrorMessage == null &&
                            usuarioController.text.isNotEmpty &&
                            senhaController.text.isNotEmpty &&
                            !_isLoading)
                        ? () => _realizarLogin(context)
                        : null,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                color: CustomColors.fontPrimaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
