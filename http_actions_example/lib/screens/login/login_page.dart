import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_actions_example/commonWidgets/custom_input.dart';
import 'package:http_actions_example/http_instance.dart';
import 'package:http_actions_example/screens/login/bloc/login_bloc.dart';
import 'package:http_actions_example/screens/login/models/login_request.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        httpActions: HttpInstance.getInstance(),
      ),
      child: const LoginPageUI(),
    );
  }
}

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({Key? key}) : super(key: key);

  @override
  State<LoginPageUI> createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final sb = const SizedBox(
    height: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                sb,
                CustomInput(
                  title: "Email",
                  controller: _emailController,
                ),
                sb,
                sb,
                CustomInput(
                  title: "Password",
                  controller: _passwordController,
                ),
                sb,
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(
                          UserLoginEvent(
                            LoginRequest(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          ),
                        );
                  },
                  child: state is LoginBusyState
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Login"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
