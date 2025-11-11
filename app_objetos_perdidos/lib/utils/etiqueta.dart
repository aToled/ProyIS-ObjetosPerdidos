import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

part 'etiqueta.g.dart';

@HiveType(typeId: 3) 
enum Etiqueta {
  @HiveField(0)
  celular("Celular", Icons.smartphone),

  @HiveField(1)
  llaves("Llaves", Icons.vpn_key),

  @HiveField(2)
  cartera("Cartera", Icons.wallet),

  @HiveField(3)
  billetera("Billetera", Icons.account_balance_wallet),

  @HiveField(4)
  utiles("Útiles", Icons.book_outlined),

  @HiveField(5)
  documento("Documento", Icons.badge_outlined),

  @HiveField(6)
  lentes("Llentes", FontAwesomeIcons.glasses),

  @HiveField(7)
  botella("Botella", FontAwesomeIcons.bottleWater),

  @HiveField(8)
  otro("Otro", Icons.label_outline);

  final String visibleName;
  final IconData iconData;

  const Etiqueta(this.visibleName, this.iconData);
}