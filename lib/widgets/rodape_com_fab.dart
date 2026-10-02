import 'package:flutter/material.dart';

/// Reserva espaço à direita do rodapé para o FloatingActionButton
/// (endFloat) não ficar por cima dele em telas de celular.
///
/// FAB padrão = 56 de largura + 16 de margem + 4 de respiro.
class RodapeComFab extends StatelessWidget {
  final Widget child;

  const RodapeComFab({super.key, required this.child});

  static const double _larguraReservada = 76;
  static const double _breakpointCelular = 600;

  @override
  Widget build(BuildContext context) {
    final bool celular = MediaQuery.of(context).size.width < _breakpointCelular;
    return Padding(
      padding: EdgeInsets.only(right: celular ? _larguraReservada : 0),
      child: child,
    );
  }
}
