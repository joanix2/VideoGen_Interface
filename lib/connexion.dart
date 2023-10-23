import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'utilities.dart';
import 'config.dart';
import 'projects_menu.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    // Émettez une notification pour informer les widgets écoutant du changement de token.
    notifyListeners();
  }

  void logout() {
    _token = null;
    // Émettez une notification pour informer les widgets écoutant de la déconnexion.
    notifyListeners();
  }
}

// Création d'un événement pour l'inscription
class SignUpEvent {}

// Création d'un état pour l'inscription
class SignUpState {}

// Création d'un bloc pour l'inscription
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState());

  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    // Logique de traitement de l'inscription ici
  }
}

// Widget de la page d'inscription
class FormPage extends StatelessWidget {
  final String name;
  final Widget form;
  const FormPage({super.key, required this.name, required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        padding: EdgeInsets.all(pad),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                // Affichage en colonne pour les écrans étroits
                return ListView(
                  children: [
                    form,
                    const LogoWidget(size: Offset(512, 512),),
                    //const SizedBox(height: Config.round1-pad/2),
                  ],
                );
              } else {
                // Affichage en ligne pour les écrans larges
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: LogoWidget(size: Offset(512, 512),),
                    ),
                    SizedBox(width: pad),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: form,
                      )
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ErrorContainer extends StatelessWidget {
  final String? errorText;

  const ErrorContainer({Key? key, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: errorText != null,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: color1,
            child: Text(
              errorText ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(height: pad),
        ],
      )
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  bool _isProcessing = false;
  String? errorMessage;

  void loginRequest({required String username, required String password, ValueChanged<http.Response>? onReceive}) async {

    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };
    http.Response? response = await sendPostRequest(view: 'login', body: requestBody);
    if (kDebugMode) {
      print(response?.statusCode);
    }
    onReceive!(response!);
    //Map<String, dynamic>? user = jsonDecode(response!.body);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          // Logique de traitement des changements d'état ici
        },
        child: FormBuilder(
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            shrinkWrap: true,
            children: [
              const MyTextWidget(text: 'Login',),
              SizedBox(height: pad*2),
              ErrorContainer(errorText: errorMessage,),
              MyTextField(
                name: 'username',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              SizedBox(height: pad),
              MyTextField(
                name: 'password',
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(8),
                ]),
              ),
              SizedBox(height: pad),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistrationPage()),
                        );
                      },
                      child: const Text(
                        "I don't have an account",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: color2,
                        ),
                      ),
                    ),
                    SizedBox(height: pad),
                    Builder(
                      builder: (BuildContext context) {
                        if (_isProcessing) {
                          return const CircularProgressIndicator();
                        } else {
                          return MyButton(
                            name: 'Sign In',
                            onPressed: () {
                              if (FormBuilder.of(context)!.validate() && !_isProcessing) {
                                FormBuilder.of(context)!.save();
                                _isProcessing = true;
                                loginRequest(
                                  username: FormBuilder.of(context)!.value['username'],
                                  password: FormBuilder.of(context)!.value['password'],
                                  onReceive: (response) {
                                    dynamic decodedBody = jsonDecode(response.body);
                                    if (kDebugMode) {
                                      print(decodedBody);
                                    }
                                    if (response.statusCode == 200) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ProjectPage(token: decodedBody['token'].toString())),
                                      );
                                    } if (decodedBody.containsKey('message')) {
                                      setState(() {
                                        errorMessage = decodedBody['message'].toString();
                                      });
                                    } else {
                                      setState(() {
                                        errorMessage = 'Error ${response.statusCode}: $decodedBody';
                                      });
                                    }
                                    _isProcessing = false;
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  bool _isProcessing = false; // Ajout de la variable _isProcessing
  String? errorMessage;
  String? passwordValue;

  void newUserRequest({required String username, required String password, ValueChanged<http.Response>? onReceive}) async {
    // Appliquer le hachage au mot de passe avec le sel

    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };
    http.Response? response = await sendPostRequest(view: 'register', body: requestBody);
    if (kDebugMode) {
      print(response?.statusCode);
    }
    onReceive!(response!);
    //Map<String, dynamic>? user = jsonDecode(response!.body);
  }

  String? _confirmPasswordValidator(String? value, {String? passwordValue}) {
    if (value != passwordValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      //key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        shrinkWrap: true,
        children: [
          const MyTextWidget(text: 'Registration',),
          SizedBox(height: pad*2),
          ErrorContainer(errorText: errorMessage,),
          MyTextField(
            name: 'username',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          SizedBox(height: pad),
          MyTextField(
            name: 'password',
            obscureText: true,
            onChanged: (value) {
              passwordValue = value;
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(8),
            ]),
          ),
          SizedBox(height: pad),
          MyTextField(
            name: 'confirm password',
            obscureText: true,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(8),
              FormBuilderValidators.required(),
                  (value) {
                return _confirmPasswordValidator(value, passwordValue: passwordValue);
              },
            ]),
          ),
          SizedBox(height: pad),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'I already have an account',
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: color2,
                    ),
                  ),
                ),
                SizedBox(height: pad),
                Builder(
                  builder: (BuildContext context) {
                    if (_isProcessing) {
                      return const CircularProgressIndicator();
                    } else {
                      return MyButton(
                        name: 'Sign Up',
                        onPressed: () {
                          if (FormBuilder.of(context)!.validate() && !_isProcessing) {
                            FormBuilder.of(context)!.save();
                            _isProcessing = true;
                            newUserRequest(
                              username: FormBuilder.of(context)!.value['username'],
                              password: FormBuilder.of(context)!.value['password'],
                              onReceive: (response) {
                                dynamic decodedBody = jsonDecode(response.body);
                                if (response.statusCode == 200) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                } if (decodedBody.containsKey('message')) {
                                  setState(() {
                                    errorMessage = decodedBody['message'].toString();
                                  });
                                } else {
                                  setState(() {
                                    errorMessage = 'Error ${response.statusCode}: $decodedBody';
                                  });
                                }
                                _isProcessing = false;
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormPage(name: 'Login', form: LoginForm());
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormPage(name: 'Registration', form: RegistrationForm());
  }
}

