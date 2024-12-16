// lib/controlador/ControladorPokemon.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Modelo/Pokemon.dart';

class ControladorPokemon {
  static const String url = 'https://pokeapi.co/api/v2/pokemon/';
  List<Pokemon> listaPokemonLocal = []; // Lista local de Pokémon

  Future<Pokemon> obtenerPokemon(int id) async {
    final response = await http.get(Uri.parse('$url$id'));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el Pokémon');
    }
  }

  Future<List<Pokemon>> obtenerListaPokemon() async {
    final response = await http.get(Uri.parse('$url?limit=20'));

    if (response.statusCode == 200) {
      List<dynamic> listaJson = json.decode(response.body)['results'];
      listaPokemonLocal.clear();  // Limpiar la lista antes de llenarla

      for (var pokemon in listaJson) {
        final urlPokemon = pokemon['url'];
        final id = int.parse(urlPokemon.split('/')[6]);

        final detallePokemon = await obtenerPokemon(id);
        listaPokemonLocal.add(detallePokemon);
      }

      return listaPokemonLocal;
    } else {
      throw Exception('Error al obtener la lista de Pokémon');
    }
  }

  // Método para agregar un Pokémon
  void agregarPokemon(Pokemon pokemon) {
    listaPokemonLocal.add(pokemon);
  }

  // Método para actualizar un Pokémon
  void actualizarPokemon(Pokemon pokemonActualizado) {
    for (var i = 0; i < listaPokemonLocal.length; i++) {
      if (listaPokemonLocal[i].id == pokemonActualizado.id) {
        listaPokemonLocal[i] = pokemonActualizado;
        break;
      }
    }
  }

  // Método para eliminar un Pokémon
  void eliminarPokemon(int id) {
    listaPokemonLocal.removeWhere((pokemon) => pokemon.id == id);
  }
}
