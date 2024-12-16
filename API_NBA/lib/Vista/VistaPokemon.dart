// lib/vista/VistaPokemon.dart

import 'package:flutter/material.dart';
import '../Controlador/ControladorPokemon.dart';
import '../Modelo/Pokemon.dart';


class VistaPokemon extends StatefulWidget {
  @override
  _VistaPokemonState createState() => _VistaPokemonState();
}

class _VistaPokemonState extends State<VistaPokemon> {
  late ControladorPokemon _controlador;
  late Future<List<Pokemon>> _pokemons;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _habilidadesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controlador = ControladorPokemon();
    _pokemons = _controlador.obtenerListaPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centra el título automáticamente
        title: Text(
          'Quien es es Pokémon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24, // Tamaño de fuente más grande
            color: Colors.white, // Color del texto
            fontFamily: 'Roboto', // Cambia la fuente si deseas algo más elegante
            letterSpacing: 1.5, // Espaciado entre letras
          ),
        ),
        backgroundColor: Colors.teal, // Color de fondo del AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _mostrarFormularioAgregar, // Se llama al método cuando se hace clic
            tooltip: 'Agregar Pokémon',
          ),
        ],
      ),

      body: FutureBuilder<List<Pokemon>>(
        future: _pokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay Pokémon disponibles'));
          }

          List<Pokemon> pokemons = snapshot.data!;

          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pokemon.imagenUrl),
                    radius: 30,
                  ),
                  title: Text(pokemon.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('Habilidades: ${pokemon.habilidades.join(', ')}', style: TextStyle(fontSize: 14)),
                  onTap: () {
                    _mostrarDetallesPokemon(pokemon);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _eliminarPokemon(pokemon.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


  // Función que muestra el formulario para agregar un Pokémon
  void _mostrarFormularioAgregar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.lime[50],
          title: Text('Agregar Pokémon', style: TextStyle(color: Colors.green)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Pokémon', labelStyle: TextStyle(color: Colors.tealAccent)),
              ),
              TextField(
                controller: _habilidadesController,
                decoration: InputDecoration(labelText: 'Habilidades (separadas por coma)', labelStyle: TextStyle(color: Colors.lightBlue)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nombre = _nombreController.text;
                // Aseguramos que habilidades sea una lista de Strings
                final habilidades = _habilidadesController.text.isNotEmpty
                    ? _habilidadesController.text.split(',').map((e) => e.trim()).toList()
                    : <String>[];

                final nuevoPokemon = Pokemon(
                  id: DateTime.now().millisecondsSinceEpoch, // Usamos un ID único temporal
                  nombre: nombre,
                  habilidades: habilidades, // Ahora es un List<String>
                  imagenUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png', // Usar una imagen por defecto
                );

                _controlador.agregarPokemon(nuevoPokemon);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Agregar', style: TextStyle(color: Colors.greenAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: Colors.indigoAccent)),
            ),
          ],
        );
      },
    );
  }


  void _mostrarDetallesPokemon(Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.teal[50],
          title: Text(pokemon.nombre, style: TextStyle(color: Colors.brown)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(pokemon.imagenUrl),
              SizedBox(height: 10),
              Text('Habilidades:', style: TextStyle(fontWeight: FontWeight.bold)),
              for (var habilidad in pokemon.habilidades) Text(habilidad),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar', style: TextStyle(color: Colors.deepPurple)),
            ),
            TextButton(
              onPressed: () {
                _mostrarFormularioActualizar(pokemon);
              },
              child: Text('Actualizar', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarFormularioActualizar(Pokemon pokemon) {
    _nombreController.text = pokemon.nombre;
    _habilidadesController.text = pokemon.habilidades.join(',');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[50],
          title: Text('Actualizar Pokémon', style: TextStyle(color: Colors.deepPurple)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Pokémon', labelStyle: TextStyle(color: Colors.deepPurple)),
              ),
              TextField(
                controller: _habilidadesController,
                decoration: InputDecoration(labelText: 'Habilidades (separadas por coma)', labelStyle: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nombre = _nombreController.text;
                final habilidades = _habilidadesController.text.split(',');
                final pokemonActualizado = Pokemon(
                  id: pokemon.id,
                  nombre: nombre,
                  habilidades: habilidades,
                  imagenUrl: pokemon.imagenUrl,
                );
                _controlador.actualizarPokemon(pokemonActualizado);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Actualizar', style: TextStyle(color: Colors.deepPurple)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }

  void _eliminarPokemon(int id) {
    _controlador.eliminarPokemon(id);
    setState(() {});
  }
}