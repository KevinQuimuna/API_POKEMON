// lib/modelo/Pokemon.dart
import 'package:api_nba/modelo/Pokemon.dart';
import 'package:flutter/material.dart';
class Pokemon {
  final int id;
  final String nombre;
  final List<String> habilidades;
  final String imagenUrl;

  Pokemon({
    required this.id,
    required this.nombre,
    required this.habilidades,
    required this.imagenUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> habilidades = [];
    for (var habilidad in json['abilities']) {
      habilidades.add(habilidad['ability']['name']);
    }
    return Pokemon(
      id: json['id'],
      nombre: json['name'],
      habilidades: habilidades,
      imagenUrl: json['sprites']['front_default'],
    );
  }
}
