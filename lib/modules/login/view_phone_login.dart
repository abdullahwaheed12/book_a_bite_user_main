import 'dart:developer';

import 'package:book_a_bite_user/controller/general_controller.dart';
import 'package:book_a_bite_user/modules/login/logic.dart';
import 'package:book_a_bite_user/modules/login/state.dart';
import 'package:book_a_bite_user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({Key? key}) : super(key: key);

  @override
  _PhoneLoginViewState createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView>
    with TickerProviderStateMixin {
  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get.find<LoginLogic>().state;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<LoginLogic>().updateOtpSendCheckerLogin(false);
      Get.find<LoginLogic>().phoneController.clear();
      Get.find<LoginLogic>().loginPhoneNumber = null;
    });
    Get.find<LoginLogic>().loginTimerAnimationController = animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 59))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {});
            }
          });
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginLogic>(
      builder: (loginLogic) => GestureDetector(
        onTap: () {
          Get.find<GeneralController>().focusOut(context);
        },
        child: GetBuilder<GeneralController>(
          builder: (generalController) => ModalProgressHUD(
            inAsyncCall: generalController.formLoader!,
            progressIndicator: const CircularProgressIndicator(
              color: customThemeColor,
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                leading: const Icon(
                  Icons.arrow_back_ios,
                  color: customThemeColor,
                  size: 25,
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Image.asset(
                            "assets/logo.png",
                            width: MediaQuery.of(context).size.width * .3,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),

                        ///---phone-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xffF6F7FC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IntlPhoneField(
                              initialCountryCode: 'NZ',
                              controller: loginLogic.phoneController,
                              style: GoogleFonts.nunito(color: Colors.black),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                filled: true,
                                fillColor: const Color(0xffF6F7FC),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                counterText: '',
                                labelText: 'Phone Number',
                                labelStyle: state.labelTextStyle,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (phone) {
                                setState(() {
                                  loginLogic.updateOtpSendCheckerLogin(false);
                                  loginLogic.loginPhoneNumber =
                                      phone.completeNumber;
                                });
                                log(phone.completeNumber);
                              },
                              onCountryChanged: (phone) {
                                loginLogic.updateOtpSendCheckerLogin(false);
                                loginLogic.phoneController.clear();
                                loginLogic.loginPhoneNumber = null;
                                setState(() {});
                                log('Country code changed to: ${phone.code}');
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),

                        loginLogic.otpSendCheckerLogin!
                            ? Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 5),
                                        child: InkWell(
                                          onTap: () {
                                            if (loginLogic
                                                    .loginTimerAnimationController!
                                                    .value ==
                                                0.0) {
                                              setState(() {
                                                loginLogic.otpFunction(
                                                    Get.find<LoginLogic>()
                                                        .loginPhoneNumber,
                                                    context);
                                                loginLogic
                                                    .loginTimerAnimationController!
                                                    .reverse(
                                                        from: loginLogic
                                                                    .loginTimerAnimationController!
                                                                    .value ==
                                                                0.0
                                                            ? 1.0
                                                            : loginLogic
                                                                .loginTimerAnimationController!
                                                                .value);
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Resend OTP Code',
                                            style: loginLogic
                                                        .loginTimerAnimationController!
                                                        .value !=
                                                    0.0
                                                ? state.registerTextStyle!
                                                    .copyWith(
                                                        color: Colors.grey
                                                            .withOpacity(0.5))
                                                : state.registerTextStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                        child: OtpTimer(
                                            loginLogic
                                                .loginTimerAnimationController!,
                                            15.0,
                                            Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Enter OTP Code Below',
                                            style: state.labelTextStyle,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
                                            child: PinCodeTextField(
                                              appContext: context,
                                              pastedTextStyle:
                                                  GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                      color: Colors.black),
                                              textStyle: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              length: 6,
                                              blinkWhenObscuring: false,
                                              animationType: AnimationType.fade,
                                              validator: (v) {
                                                if (v!.length < 6) {
                                                  return "Enter Correct Pin";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              pinTheme: PinTheme(
                                                  shape: PinCodeFieldShape.box,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  fieldHeight: 36,
                                                  fieldWidth: 40,
                                                  activeFillColor: Colors.white,
                                                  disabledColor: Colors.white,
                                                  activeColor: customThemeColor,
                                                  inactiveFillColor:
                                                      const Color(0xffF6F7FC),
                                                  errorBorderColor: Colors.red,
                                                  inactiveColor:
                                                      customThemeColor,
                                                  selectedFillColor:
                                                      const Color(0xffF6F7FC),
                                                  selectedColor:
                                                      customThemeColor,
                                                  borderWidth: 1),
                                              cursorColor: Colors.black,
                                              animationDuration: const Duration(
                                                  milliseconds: 300),
                                              enableActiveFill: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              onCompleted: (v) {
                                                log("Completed");
                                              },
                                              onChanged: (value) {
                                                log(value);
                                                setState(() {
                                                  loginLogic.loginOtp =
                                                      value.toString();
                                                });
                                              },
                                              beforeTextPaste: (text) {
                                                log("Allowing to paste $text");
                                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                return true;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            Get.find<GeneralController>()
                                                .updateFormLoader(true);
                                            loginLogic.verifyOTP(context,
                                                loginLogic.loginOtp, false);
                                          },
                                          child: Container(
                                            height: 55,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: customThemeColor,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: customThemeColor
                                                      .withOpacity(0.19),
                                                  blurRadius: 40,
                                                  spreadRadius: 0,
                                                  offset: const Offset(0,
                                                      22), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text("Submit",
                                                  style: state.buttonTextStyle),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: InkWell(
                                  onTap: () async {
                                    generalController.focusOut(context);
                                    if (_loginFormKey.currentState!
                                        .validate()) {
                                      loginLogic.otpFunction(
                                          Get.find<LoginLogic>()
                                              .loginPhoneNumber,
                                          context);
                                      loginLogic.loginTimerAnimationController!.reverse(
                                          from: loginLogic
                                                      .loginTimerAnimationController!
                                                      .value ==
                                                  0.0
                                              ? 1.0
                                              : loginLogic
                                                  .loginTimerAnimationController!
                                                  .value);
                                      loginLogic
                                          .updateOtpSendCheckerLogin(true);
                                    }
                                  },
                                  child: Container(
                                    height: 55,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: customThemeColor,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: customThemeColor
                                              .withOpacity(0.19),
                                          blurRadius: 40,
                                          spreadRadius: 0,
                                          offset: const Offset(0,
                                              22), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text("Login",
                                          style: state.buttonTextStyle),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtpTimer extends StatelessWidget {
  final state = Get.find<LoginLogic>().state;

  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration? duration = controller.duration;
    return duration!;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Text(timerString, style: state.labelTextStyle);
        });
  }
}
