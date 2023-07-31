import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_bloc.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_event.dart';
import 'package:poc_supero_btt/blocs/person/bloc/person_state.dart';
import 'package:poc_supero_btt/pages/person_address_info.dart';
import 'package:poc_supero_btt/utils/cpf_validator.dart';

class PersonInfoPage extends StatefulWidget {
  const PersonInfoPage({Key? key}) : super(key: key);

  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var getIt = GetIt.instance;
    var bloc = getIt<PersonBloc>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Info. pessoal'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: BlocBuilder<PersonBloc, PersonState>(
              bloc: bloc,
              builder: (context, state) {
                var statePerson = (state as PersonDefaultState);
                var person = statePerson.person;
                return ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Nome'),
                      onChanged: (name) => bloc.add(PersonEventUpdate(
                          name: name,
                          stateAddress: person.stateAddress,
                          stateId: person.stateId ?? 0,
                          city: person.city,
                          cityId: person.cityId ?? 0)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome.';
                        }
                        return null; // Retorna null se o valor for válido
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'CPF'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um CPF.';
                        } else if (!isValidCPF(value)) {
                          return 'CPF inválido.';
                        }
                        return null; // Retorna null se o valor for válido
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [cpfMaskFormatter],
                      onChanged: (cpf) => bloc.add(PersonEventUpdate(
                          cpf: cpf,
                          stateAddress: person.stateAddress,
                          stateId: person.stateId ?? 0,
                          city: person.city,
                          cityId: person.cityId ?? 0)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Nome da Mãe'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome da mãe.';
                        }
                        return null; // Retorna null se o valor for válido
                      },
                      onChanged: (nameMother) => bloc.add(PersonEventUpdate(
                          nomeMae: nameMother,
                          stateAddress: person.stateAddress,
                          stateId: person.stateId ?? 0,
                          city: person.city,
                          cityId: person.cityId ?? 0)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Nome do Pai'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome do pai.';
                        }
                        return null; // Retorna null se o valor for válido
                      },
                      onChanged: (nameFather) => bloc.add(PersonEventUpdate(
                          nomePai: nameFather,
                          stateAddress: person.stateAddress,
                          stateId: person.stateId ?? 0,
                          city: person.city,
                          cityId: person.cityId ?? 0)),
                    ),
                    const SizedBox(height: 32),
                    // Padding(
                    //   padding: const EdgeInsets.all(16),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text('Nome: ${person.name}'),
                    //       Text('CPF: ${person.cpf}'),
                    //       Text('Nome da Mãe: ${person.nomeMae}'),
                    //       Text('Nome do Pai: ${person.nomePai}'),
                    //       Text('Estado: ${person.selectedState?.nome ?? ''}'),
                    //       Text('Estado ID: ${person.selectedState?.id ?? ''}'),
                    //       Text('Cidade: ${person.selectedCity?.nome ?? ''}'),
                    //       Text('Cidade ID: ${person.selectedCity?.id ?? ''}'),
                    //       // Text('Foto base64: ${person.photo}'),
                    //       Text('Endereço: ${person.address}'),
                    //     ],
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        // Verifica se o formulário é válido
                        if (_formKey.currentState!.validate()) {
                          // Navega para a próxima página
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PersonAddressInfo(
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
