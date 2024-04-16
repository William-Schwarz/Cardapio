import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/configs/theme/snack_bar.dart';
import 'package:cardapio/controller/new_page.dart';
import 'package:cardapio/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigation extends StatefulWidget {
  final int index;
  const Navigation({Key? key, this.index = 0}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _indiceAtual = 0;
  final List<String> _titulos = ['Cardápio', 'Avaliações', 'Atualizar'];
  final List<Widget> _telas = [
    const NewPage(0),
    const NewPage(1),
    const NewPage(2),
  ];

  late User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
    _indiceAtual = widget.index;
  }

  Future<void> _getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: CustomColors.primaryGradient,
          ),
          child: Center(
            child: Text(
              _titulos[_indiceAtual],
              style: const TextStyle(
                color: CustomColors.fontPrimaryColor,
                fontSize: 20,
              ),
            ),
          ),
        ),
        actions: [
          Center(
            child: Row(
              children: [
                Text(
                  _user != null ? 'Sair' : 'Entrar',
                  style: const TextStyle(
                    color: CustomColors.fontPrimaryColor,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  onPressed: _handleAuthentication,
                  icon: _user != null
                      ? const Icon(Icons.logout)
                      : const Icon(Icons.login),
                  color: CustomColors.fontPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: _telas.elementAt(_indiceAtual),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: CustomColors.primaryGradient,
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: CustomColors.fontPrimaryColor,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Cardápio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: 'Avaliações',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Atualizar',
            ),
          ],
        ),
      ),
    );
  }

  void _handleAuthentication() {
    if (_user != null) {
      _signOut();
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginView(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    }
  }

  void onItemTapped(int index) {
    if (_user != null || index != 2) {
      setState(() {
        _indiceAtual = index;
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      CustomSnackBar.showDefault(context,
          'Você precisa estar logado para acessar esta funcionalidade.');
    }
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        _user = null;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      CustomSnackBar.showDefault(
        context,
        'Logout realizado com sucesso!',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer logout: $e');
      }
    }
  }
}
