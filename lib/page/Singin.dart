import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';

void main() {
  runApp(const Signin());
}

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Signin_(),
    );
  }
}

class Signin_ extends StatefulWidget {
  const Signin_({super.key});

  @override
  State<Signin_> createState() => _Signin_State();
}

class _Signin_State extends State<Signin_> {
  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              Container(height: 160, child: Image.asset('asset/logo.png')),

              SizedBox(height: 8),

              Text(
                'Welcome to Spean Meas HMS', //
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Container(
                width: 500,
                child: TextField(decoration: InputDecoration(labelText: 'Username')),
              ),

              SizedBox(height: 8),

              Container(
                width: 500,
                child: TextField(decoration: InputDecoration(labelText: 'Password')),
              ),

              SizedBox(height: 8),

              OutlinedButton.icon(
                icon: Icon(Icons.login), //
                label: Text('Signin'),
                onPressed: () {},
              ),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }
}
