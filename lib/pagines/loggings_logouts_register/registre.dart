import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/usuarisProvider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para trabajar con archivos

class Registre extends StatefulWidget {
  const Registre({super.key});

  @override
  _RegistreState createState() => _RegistreState();
}

class _RegistreState extends State<Registre> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController correuController = TextEditingController();
  final TextEditingController contrasenyaController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController nacionalitatController = TextEditingController();
  final TextEditingController codiPostalController = TextEditingController();
  final TextEditingController imatgePerfilController = TextEditingController();

  File? _selectedImage; // Almacenar la imagen seleccionada

  final ImagePicker _picker = ImagePicker();
  bool _isPickerActive = false; // Para evitar múltiples llamadas al picker

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UsuarisProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registre',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C4B4),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFF181A20),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Tots els camps són obligatoris',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              _buildTextField(nomController, 'Nom', 'Introdueix el teu nom'),
              _buildTextField(
                  correuController, 'Correu', 'Introdueix el teu correu'),
              _buildTextField(contrasenyaController, 'Contrasenya',
                  'Introdueix la contrasenya'),
              _buildTextField(
                  edadController, 'Edad', 'Introdueix la teva edat'),
              _buildTextField(nacionalitatController, 'Nacionalitat',
                  'Introdueix la teva nacionalitat'),
              _buildTextField(codiPostalController, 'Codi Postal',
                  'Introdueix el teu codi postal'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecciona la teva imatge de perfil:',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isPickerActive
                              ? null
                              : _pickImage, // Deshabilitar el botón si el picker está activo
                          child: const Text('Seleccionar Imatge'),
                        ),
                        const SizedBox(width: 10),
                        _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Text(
                                'Cap imatge seleccionada',
                                style: TextStyle(color: Colors.white),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Comprobar si algún campo está vacío

                  String nom = nomController.text;
                  String correu = correuController.text;
                  String contrasenya = contrasenyaController.text;
                  String edad = edadController.text;
                  String nacionalitat = nacionalitatController.text;
                  String codiPostal = codiPostalController.text;
                  String imatgePerfil = imatgePerfilController.text;

                  if (nom.isEmpty ||
                      correu.isEmpty ||
                      contrasenya.isEmpty ||
                      edad.isEmpty ||
                      nacionalitat.isEmpty ||
                      codiPostal.isEmpty ||
                      imatgePerfil.isEmpty) {
                    // Mostrar un mensaje de error si algún campo está vacío
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Tots els camps són obligatoris')),
                    );
                  } else {
                    // Verificar si el correo ya existe en la lista de usuarios
                    if (provider.getUsuaris.any((u) => u.correu == correu)) {
                      // Mostrar un mensaje de error si el correo ya existe
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Aquest correu ja està registrat')),
                      );
                    } else {
                      // Calcular el nuevo ID automáticamente
                      int newId = (provider.getUsuaris.isNotEmpty
                              ? provider.getUsuaris
                                  .map((u) => u.id)
                                  .reduce((a, b) => a > b ? a : b)
                              : 0) +
                          1;
                      int edadEntera = int.parse(edad);

                      // Crear el nuevo usuario y añadirlo a la lista
                      Usuari nouUsuari = Usuari(
                        id: newId,
                        nom: nom,
                        correu: correu,
                        contrasenya: contrasenya,
                        edat: edadEntera,
                        nacionalitat: nacionalitat,
                        codiPostal: codiPostal,
                        imatgePerfil: imatgePerfil,
                      );

                      provider.addUsuari(
                          nouUsuari); // Añadir el nuevo usuario al provider

                      // Mostrar un mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Usuari registrat amb èxit!')),
                      );

                      // Volver a la página de login
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Registrar-me'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isPickerActive = true;
    });

    // Verificar si se han concedido permisos antes de abrir la galería
    await _requestPermission();

    // Seleccionar imagen desde la galería
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        imatgePerfilController.text =
            _selectedImage!.path; // Asignar el path a un TextEditingController
      });
    }

    setState(() {
      _isPickerActive = false;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de acceso a fotos aceptadoo')),
      );
    }
  }

  // Widget auxiliar para construir campos de texto
  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          filled: false,
        ),
      ),
    );
  }
}
