import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/app/routes.dart';
import 'package:flutter_tunes/app/themes.dart';
import 'package:flutter_tunes/common/consts.dart';
import 'package:flutter_tunes/views/login/login_provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'login_status.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnfPasswordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Show user if the app is offline
    if (BlocProvider.of<AppBloc>(context).state.connectivity ==
        ConnectivityResult.none) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'You are currently offline. \nPlease enable internet connection')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider()..initialize(),
      child: Consumer<LoginProvider>(
        builder: (builderContext, provider, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.getScaffoldBackground(context),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 36.0, top: 80.0, right: 36.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(StringConsts.appLogo, height: 148),
                      const SizedBox(height: 24.0),
                      const Text(
                        "FLUTTER TUNES",
                        style: TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      const SizedBox(height: 20.0),
                      Text(
                        _getTitle(builderContext),
                        style: const TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormBuilderValidators.email(),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.loginStatus == LoginStatus.newUser,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            maxLength: 25,
                            decoration: InputDecoration(
                              hintText: 'Your Name',
                              filled: true,
                              counterText: "",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.loginStatus == LoginStatus.newUser ||
                            provider.loginStatus == LoginStatus.unauthenticated,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            maxLength: 25,
                            validator: FormBuilderValidators.minLength(6),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.loginStatus == LoginStatus.newUser,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: TextFormField(
                            obscureText: true,
                            controller: _cnfPasswordController,
                            validator: FormBuilderValidators.minLength(6),
                            decoration: InputDecoration(
                              hintText: 'Confirm password',
                              filled: true,
                              counterText: "",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (provider.loginStatus == LoginStatus.newUser) {
                              if (_passwordController.text.trim() ==
                                  _cnfPasswordController.text.trim()) {
                                final result = await provider.signUpUser(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim());
                                if (result != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "User created successfully")));
                                  BlocProvider.of<AppBloc>(context)
                                      .add(UserLoginEvent(user: result));
                                  Navigator.of(context)
                                      .pushReplacementNamed(AppRouteNames.home);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Something went wrong. Please try again")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Passwords do not match")));
                              }
                            } else if (provider.loginStatus ==
                                LoginStatus.unauthenticated) {
                              final result = provider.verifyLogin(
                                  password: _passwordController.text.trim());
                              if (result) {
                                BlocProvider.of<AppBloc>(context).add(
                                    UserLoginEvent(
                                        user: provider.existingUser));
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRouteNames.home);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Incorrect password")));
                              }
                            } else {
                              provider.checkUserExists(
                                  email: _emailController.text.trim());
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(_getButtonTitle(builderContext)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    switch (provider.loginStatus) {
      case LoginStatus.newUser:
        return StringConsts.signUp;

      case LoginStatus.unauthenticated:
        return "Welcome Back, ${provider.existingUser?.name ?? "User"}!";

      default:
        return StringConsts.emailToProceed;
    }
  }

  String _getButtonTitle(BuildContext context) {
    final loginStatus = Provider.of<LoginProvider>(context).loginStatus;
    switch (loginStatus) {
      case LoginStatus.newUser:
        return "SIGN UP";

      case LoginStatus.unauthenticated:
        return "LOGIN";

      default:
        return "SUBMIT";
    }
  }
}