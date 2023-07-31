import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_bloc.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_event.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_state.dart';
import 'package:poc_supero_btt/models/city.dart';
import 'package:poc_supero_btt/models/state.dart';
import 'package:poc_supero_btt/pages/person_picture_info.dart';
import 'package:poc_supero_btt/services/ibge_service.dart';

class PersonAddressInfo extends StatefulWidget {
  final PersonBloc bloc;

  const PersonAddressInfo({Key? key, required this.bloc}) : super(key: key);

  @override
  State<PersonAddressInfo> createState() => _PersonAddressInfoState();
}

class _PersonAddressInfoState extends State<PersonAddressInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  List<StateData> _statesList = [];
  List<CityData> _citiesList = [];
  StateData? _selectedState;
  CityData? _selectedCity;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;
  final IbgeService ibgeService = IbgeService();
  bool _isStateSelected = false;
  bool _isCitySelected = false;

  get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();
    _fetchStatesData();
  }

  Future<void> _fetchStatesData() async {
    setState(() {
      _isLoadingStates = true;
    });

    try {
      final List<StateData> responseData = await ibgeService.fetchStatesData();

      setState(() {
        _statesList = responseData;
        _isLoadingStates = false;
      });
    } catch (error) {
      print('Error while fetching states data: $error');
      setState(() {
        _isLoadingStates = false;
      });
    }
  }

  Future<void> _fetchCitiesData(int stateId) async {
    setState(() {
      _isLoadingCities = true;
    });

    try {
      final List<CityData> responseData =
          await ibgeService.fetchCitiesData(stateId);

      setState(() {
        _citiesList = responseData;
        _isLoadingCities = false;
      });
    } catch (error) {
      print('Error while fetching cities data: $error');
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enderço'),
        ),
        body: _isLoadingStates
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
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
                          TextFormField(
                            initialValue: person.address,
                            decoration:
                                const InputDecoration(hintText: 'Endereço'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o endereço.';
                              }
                              return null; // Retorna null se o valor for válido
                            },
                            onChanged: (address) =>
                                bloc.add(PersonEventUpdate(address: address)),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<StateData>(
                            value: _selectedState,
                            items: _statesList.map((state) {
                              return DropdownMenuItem<StateData>(
                                value: state,
                                child: Text(state.nome),
                              );
                            }).toList(),
                            onChanged: (state) {
                              if (state != null) {
                                var nome = state.nome;
                                var id = state.id;
                                setState(() {
                                  _selectedState = state;
                                  _selectedCity = null;
                                  _citiesList.clear();
                                  _isStateSelected =
                                      true; // Estado foi selecionado
                                  _isCitySelected = false;
                                });

                                bloc.add(PersonEventUpdate(
                                    selectedState: state,
                                    stateAddress: nome,
                                    stateId: id,
                                    selectedCity: null,
                                    city: '',
                                    cityId: 0));

                                _fetchCitiesData(id);
                              }
                            },
                            validator: (value) {
                              if (!_isStateSelected) {
                                return 'Por favor, selecione um Estado.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Selecionar Estado',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<CityData>(
                            value: _selectedCity,
                            items: _citiesList.map((city) {
                              return DropdownMenuItem<CityData>(
                                value: city,
                                child: Text(city.nome),
                              );
                            }).toList(),
                            onChanged: (city) {
                              if (city != null) {
                                setState(() {
                                  _selectedCity = city;
                                  _isCitySelected = true;
                                });

                                bloc.add(PersonEventUpdate(
                                  selectedCity: city,
                                  city: city.nome,
                                  cityId: city.id,
                                ));
                              }
                            },
                            validator: (value) {
                              if (!_isCitySelected) {
                                return 'Por favor, selecione uma Cidade.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Selecionar Cidade',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              // Verifica se o formulário é válido (incluindo os Dropdowns)
                              if (_formKey.currentState!.validate() &&
                                  _isStateSelected &&
                                  _isCitySelected) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => PersonPictureInfo(
                                    bloc: bloc,
                                  ),
                                ));
                              }
                            },
                            child: const Text('Próximo'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ));
  }
}
