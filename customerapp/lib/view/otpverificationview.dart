import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class Otpverification extends StatefulWidget {
  static String id = 'otpverification';
  @override
  _OtpverificationState createState() => _OtpverificationState();
}

class _OtpverificationState extends State<Otpverification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Otp Verification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: TextFormField(
                obscureText: false,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Mobile No',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '(+94) ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  suffixIcon: const Icon(
                    Icons.done_outline_sharp,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RichText(
                  text: const TextSpan(
// Note: Styles for TextSpans must be explicitly defined.
// Child text spans will inherit styles from parent

                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'We will send you an '),
                      TextSpan(
                          text: 'One Time Password ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'on this number '),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.all(15),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: Colors.grey)),
                ),
                onPressed: () {
//   Navigator.pushNamed(context, OtpVerify.id);
                },
                child: Text('Get OTP'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  const Text(
                    'We have texted you a code please enter it below',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  OtpTextField(
                    numberOfFields: 5,
                    borderColor: Colors.black,
//set to true to show as box or false to show as dash
                    showFieldAsBox: true,
//runs when a code is typed in
                    onCodeChanged: (String code) {
//handle validation or checks here
                    },
//runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Verification Code"),
                              content:
                                  Text('Code entered is $verificationCode'),
                            );
                          });
                    }, // end onSubmit
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              margin: const EdgeInsets.only(right: 30, bottom: 20, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Didn\'t Receive OTP?'),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.grey)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Resent OTP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.all(15),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: Colors.grey)),
                ),
                onPressed: () {
//   Navigator.pushNamed(context, OtpVerify.id);
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
