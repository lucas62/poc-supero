import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_bloc.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_state.dart';
import 'package:poc_supero_btt/pages/person_info_page.dart';
import 'package:poc_supero_btt/services/api_services.dart';

import '../blocs/person/bloc/person_event.dart';

class PersonPictureInfo extends StatefulWidget {
  final PersonBloc bloc;

  const PersonPictureInfo({Key? key, required this.bloc}) : super(key: key);

  @override
  _PersonPictureInfoState createState() => _PersonPictureInfoState();
}

class _PersonPictureInfoState extends State<PersonPictureInfo> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _image;
  String? _imageAsBase64;

  get bloc => widget.bloc;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _takePicture(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _imageAsBase64 =
            null; // Reset base64 representation when a new image is taken
      });

      await _getImageAsBase64(File(pickedImage.path), pickedImage.path);
    }
  }

  void _removePicture() {
    setState(() {
      _image = null;
      _imageAsBase64 = null;
    });
  }

  Future<void> _getImageAsBase64(File image, String path) async {
    List<int> imageBytes = await image.readAsBytes();
    String encode = base64Encode(imageBytes);

    setState(() {
      _imageAsBase64 = encode;

      bloc.add(PersonEventUpdate(
        photoBase64: _imageAsBase64,
        photoPath: path,
      ));
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Form is valid, create the Person object from the form data
      final personState = bloc.state as PersonDefaultState;
      final person = personState.person;

      // Call the API to submit the form
      _apiService.postPersonForm(person).then((_) {
        setState(() {
          _isLoading = false;
        });
        // Form submitted successfully, you can show a success message or navigate to another screen
        // For example:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Formulário enviado'),
            content: const Text('Formulário enviado com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  // Reset navigation to PersonInfoPage
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonInfoPage(),
                    ),
                    (route) =>
                        false, // Pop all routes until the new route is added
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        // Handle the error when form submission fails
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('Um erro ocorreu ao enviar o fomulário.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Info. Foto'),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: BlocBuilder<PersonBloc, PersonState>(
                  bloc: bloc,
                  builder: (context, state) {
                    var statePerson = (state as PersonDefaultState);
                    var person = statePerson.person;
                    return ListView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_image != null)
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 225,
                                      child: Image.file(_image!,
                                          fit: BoxFit.contain),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _takePicture(ImageSource.camera);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Tirar outra foto',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _takePicture(ImageSource.gallery);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Selecionar da Galeria',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: _removePicture,
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Remover foto',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                SizedBox(
                                  height: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            _takePicture(ImageSource.camera);
                                          },
                                          icon: const Icon(Icons.add),
                                          label: const Text(
                                            'Adicionar Imagem',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor:
                                                const Color(0xFFE9F5F9),
                                            side: const BorderSide(
                                                color: Colors.blue),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _takePicture(ImageSource.gallery);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Selecionar da Galeria',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Enviar Formulário'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors
                    .black54, // A semi-transparent black color as an overlay
                child: const Center(
                  child: CircularProgressIndicator(), // Loading indicator
                ),
              ),
          ],
        ));
  }
}
