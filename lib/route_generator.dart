import 'package:flutter/material.dart';
import 'package:mobile/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MyHomePage());

      case '/second':
        if (args is bool && args == true) {
          return MaterialPageRoute(builder: (_) => const SecondPage());
        }
        return _accessDenied();

      case '/third':
        if (args is bool && args == true) {
          return MaterialPageRoute(builder: (_) => const ThirdPage());
        }
        return _accessDenied();

      default:
        return _notFound();
    }
  }

  static Route<dynamic> _notFound() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Página não encontrada'),
        ),
        body: const Center(
          child: Text('Erro 404: Página não encontrada'),
        ),
      );
    });
  }

  static Route<dynamic> _accessDenied() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Acesso Negado'),
        ),
        body: const Center(
          child: Text('Você não tem permissão para acessar esta página.'),
        ),
      );
    });
  }

  static Route<dynamic> _typeError(Object? args) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro de tipagem da rota: $args'),
        ),
        body: Center(
          child: Text('Erro de tipagem da rota: $args'),
        ),
      );
    });
  }
}