import 'dart:convert';

import 'package:customerapp/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global_urls.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobilenoController = new TextEditingController();
  TextEditingController _otpController = new TextEditingController();
  String countryMobNo = '0';
  bool loading = false;
  bool loading2 = false;
  bool sent = false;

  Future<void> getOTP(String phn) async {
    setState((){loading = true;});
    var request = http.Request('POST', Uri.parse('${Urls.apiUrl}/auth/req-otp?phoneNo=$phn'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      setState((){sent = true;});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('One Time Password Sent'),),
      );
    }
    else {
      print(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Sending Failed!'),),
      );
    }
    setState((){loading = false;});
  }

  Future<void> login(String phone, String otp) async {
    setState((){loading2 = true;});
    String tok ='';
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${Urls.apiUrl}/auth/login'));
    request.body = json.encode({
      "userID": phone,
      "password": otp,
      "userType": "CS"
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState((){loading2 = false;});
      tok = await response.stream.bytesToString();
      print(tok);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You Are Signed In!'),),
      );
      setPrefs(phone, tok);
    }
    else {
      setState((){loading2 = false;});
      print(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign In Failed!'),),
      );
    }
  }

  Future<void> setPrefs(String phone, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('auth', 1);
    await prefs.setString('phone', phone);
    await prefs.setString('token', token);
    Auth.token = token;
    Auth.userId = phone;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 30, left: 10, right: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'We will send you an ',
                          style: TextStyle(fontSize: 16)),
                      TextSpan(
                          text: 'One Time Password ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                        text: 'to your Mobile number ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _mobilenoController,
                  obscureText: false,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: "Your Phone Number",
                    prefix: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        '+94',
                      ),
                    ),
                  ),
                  validator: (value) {
                    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value!.isEmpty) {
                      return 'Please enter your mobile number';
                    } //else if (!regExp.hasMatch(value)) {
                    //return 'Please enter valid mobile number';
                    //}
                    return null;
                  },
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          countryMobNo = '%2B94${_mobilenoController.text}';
                          print(countryMobNo);
                          getOTP(countryMobNo);
                        } else {
                          return null;
                        }
                      },
                      child: (loading)?
                      SizedBox(width: 20,height: 20,child: CircularProgressIndicator(color: Colors.white,),):Text('SEND OTP'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _otpController,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: (sent)? () {
                        login("+94${_mobilenoController.text}", _otpController.text);
                      }: null,
                      child: (loading2)?
                      SizedBox(width: 20,height: 20,child: CircularProgressIndicator(color: Colors.white,),):Text('CONFIRM'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

