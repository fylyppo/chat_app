import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/widgets/pickers/user_image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('Messages App'),
                Form(
                    key: auth.formkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        if (!auth.isLogin)
                          UserImagePickerWidget(pickProfileImage: auth.pickedImage),
                        TextFormField(
                          key: ValueKey('email'),
                          initialValue: '',
                          decoration:
                              InputDecoration(hintText: 'Email address'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            auth.userEmail = value!;
                          },
                        ),
                        if (!auth.isLogin)
                          TextFormField(
                            key: const ValueKey('username'),
                            decoration: const InputDecoration(hintText: 'Username'),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Please enter at least 4 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              auth.userName = value!;
                            },
                          ),
                        TextFormField(
                          controller: auth.pass,
                          key: ValueKey('password'),
                          decoration: InputDecoration(hintText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Password must be at least 7 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            auth.userPassword = value!;
                          },
                        ),
                        if (!auth.isLogin)
                          TextFormField(
                            controller: auth.confirmPass,
                            key: ValueKey('repeatPassword'),
                            decoration:
                                InputDecoration(hintText: 'Repeat password'),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password must be at least 7 characters long.';
                              }
                              if (value != auth.pass.text)
                                return 'Passwords does not match.';
                              return null;
                            },
                          ),
                        auth.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : TextButton.icon(
                                onPressed: () => auth.trySubmit(context),
                                icon: Icon(Icons.login),
                                label: Text(auth.isLogin ? 'Login' : 'Register')),
                        TextButton(
                            onPressed: () {
                                auth.isLogin = !auth.isLogin;
                            },
                            child: Text(auth.isLogin ? 'Sign Up' : 'Sign In')),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
