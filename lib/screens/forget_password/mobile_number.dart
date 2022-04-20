import 'package:borderpay/Route_Constants/route_constants.dart';
import 'package:borderpay/app_theme/theme.dart';
import 'package:borderpay/model/datamodels/login_user_model.dart';
import 'package:borderpay/repo/auth_repo/auth_repo.dart';
import 'package:borderpay/repo/auth_repo/auth_repo_impl.dart';
import 'package:borderpay/screens/custom_intl_phone_field.dart';
import 'package:borderpay/widget/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key? key}) : super(key: key);

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  AuthRepo networkHandler = AuthRepoImpl();

  TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  String cuntryCode = '+1';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.36.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacer(30),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 37.26.h,
                          width: 37.26.w,
                          // margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10.11.r,
                            ),
                            color: CustomizedTheme.colorAccent,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: CustomizedTheme.white,
                          ),
                        ),
                      ),
                      horizontalSpacer(16),
                      Text(
                        "Phone Number",
                        style: CustomizedTheme.title_p_W500_21,
                      ),
                    ],
                  ),
                  verticalSpacer(16),
                  SizedBox(
                    height: 68.54.h,
                  ),
                  CustomIntlPhoneField(
                    flagDecoration: BoxDecoration(
                      color: CustomizedTheme.primaryBold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    initialCountryCode: 'US',
                    controller: phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0.r,
                          ),
                        ),
                        borderSide: BorderSide(
                          color: CustomizedTheme.colorAccent,
                          width: .01.w,
                        ),
                      ),
                      label: const Text("Phone Number"),
                      labelStyle: TextStyle(
                        color: CustomizedTheme.colorAccent,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0.r,
                          ),
                        ),
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0.r,
                          ),
                        ),
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 1.w,
                        ),
                      ),
                    ),
                    onChanged: (phone) {},
                    onCountryChanged: (country) {
                      setState(
                        () {
                          cuntryCode = "+" + country.dialCode;
                        },
                      );
                    },
                    dropdownIconPosition: IconPosition.trailing,
                    flagsButtonPadding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                  SizedBox(
                    height: 15.53.h,
                  ),
                  SizedBox(height: 100.16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 61.07.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            color: CustomizedTheme.colorAccent,
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (!isLoading &&
                                  phoneController.text.length > 6) {
                                setState(() {
                                  isLoading = true;
                                });
                                forgetPassword();
                              }
                            },
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Next",
                                    style: CustomizedTheme.w_W500_19,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> forgetPassword() async {
    Map<String, String> loginData = {
      "mobileNumber": cuntryCode + phoneController.text,
    };
    var res = await networkHandler.forgetPassword(loginData);
    if (res != null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("OTP sent!"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: CustomizedTheme.voucherPaid,
      ));
      Navigator.pushNamed(
        context,
        RouteConstant.forgetOtp,
        arguments: cuntryCode + phoneController.text,
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Invalid Phone Number!"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: CustomizedTheme.voucherUnpaid,
      ));
    }
  }
}