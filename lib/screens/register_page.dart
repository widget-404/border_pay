import 'package:borderpay/Utils/utils.dart';
import 'package:borderpay/app_theme/theme.dart';
import 'package:borderpay/controllers/countries_controller.dart';
import 'package:borderpay/model/arguments/register_first.dart';
import 'package:borderpay/model/datamodels/countries_data_model.dart';
import 'package:borderpay/widget/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';

import '../Utils/sharedPrefKeys.dart';
import '../Utils/sharedpref.dart';
import '../localization/app_localization.dart';
import '../localization/translation_keys.dart';
import 'intl_phone_number_dropdown/custom_intl_phone_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CountriesController countriesController = Get.find<CountriesController>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController currentNationality = TextEditingController();
  String countryISO = '';
  List<String> localCountries = List.empty(growable: true);
  String currentAreaCode = '+971';
  bool allCompleted = false;
  bool termsAndCondition = false;


  int selectedLang = 0;

  @override
  void initState() {
    selectedLang = MySharedPreferences.instance
        .getIntValue(SharedPrefKeys.selectedLanguage);

    getCountries(countriesController.countries);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Row(
          children: [
            SizedBox(width: 20.w),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 33.73.h,
                  width: 33.73.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        9.16.r,
                      ),
                      color: CustomizedTheme.colorAccent),
                  child: Icon(
                    Icons.arrow_back,
                    color: CustomizedTheme.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
            AppLocalizations.of(context)!.translate(
              TranslationKeys.register,
            ),
            style: CustomizedTheme.title_p_W500_21),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.36.w,
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: Utils.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: fnameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 24.44.w,
                          right: 34.47.w,
                          bottom: 12.3.h,
                          top: 15.03.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0.r,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0.w,
                          ),
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          TranslationKeys.firstName,
                        ),
                        labelStyle: CustomizedTheme.b_W400_12,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0.r,
                            ),
                          ),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return AppLocalizations.of(context)!.translate(
                            TranslationKeys.firstNameIsEmpty,
                          );
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 35.53.h,
                    ),
                    TextFormField(
                      controller: lnameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 24.44.w,
                          right: 34.47.w,
                          bottom: 12.3.h,
                          top: 15.03.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0.r,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0.w,
                          ),
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          TranslationKeys.lastName,
                        ),
                        labelStyle: CustomizedTheme.b_W400_12,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0.r,
                            ),
                          ),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return AppLocalizations.of(context)!.translate(
                            TranslationKeys.lastNameIsEmpty,
                          );
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 35.53.h,
                    ),
                    // buildPhoneDD(),
                    CustomIntlPhoneField(
                      locale: selectedLang,
                      flagDecoration: BoxDecoration(
                        color: CustomizedTheme.primaryBold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      initialCountryCode: 'US',
                      controller: phoneController,
                      decoration: InputDecoration(
                        label: Text(
                          AppLocalizations.of(context)!.translate(
                            TranslationKeys.phoneNumber,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: CustomizedTheme.colorAccent,
                        ),
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
                            currentAreaCode = "+" + country.dialCode;
                          },
                        );
                      },
                      dropdownIconPosition: IconPosition.trailing,
                      flagsButtonPadding:
                          const EdgeInsets.symmetric(vertical: 8),
                    ),

                    SizedBox(
                      height: 25.53.h,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 24.44.w,
                          right: 34.47.w,
                          bottom: 12.3.h,
                          top: 15.03.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0.r,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0.w,
                          ),
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          TranslationKeys.emailID,
                        ),
                        labelStyle: CustomizedTheme.b_W400_12,
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0.r)),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      // controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (!GetUtils.isEmail(value!)) {
                          return AppLocalizations.of(context)!.translate(
                            TranslationKeys.enterValidEmail,
                          );
                        }
                        // Return null if the entered email is valid
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 35.53.h,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: currentNationality,
                      validator: (value) {
                        if (currentNationality.text.isEmpty) {
                          return AppLocalizations.of(context)!.translate(
                            TranslationKeys.nationalityIsEmpty,
                          );
                        }
                        // Return null if the entered email is valid
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 24.44.w,
                            right: 34.47.w,
                            bottom: 12.3.h,
                            top: 15.03.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10.0.r,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0.w,
                            ),
                          ),
                          labelText: AppLocalizations.of(context)!.translate(
                            TranslationKeys.nationality,
                          ),
                          labelStyle: CustomizedTheme.b_W400_12,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10.0.r,
                              ),
                            ),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          suffixIcon: const Icon(Icons.arrow_drop_down)),
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          countryFilter: localCountries,
                          showPhoneCode: false,
                          showWorldWide: false,
                          onSelect: (Country country) {
                            setState(
                              () {
                                currentNationality.text = country.name;
                                countryISO = country.countryCode;
                              },
                            );
                          },
                          countryListTheme: CountryListThemeData(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            // Optional. Styles the search field.
                            inputDecoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.translate(
                                TranslationKeys.search,
                              ),
                              hintText: AppLocalizations.of(context)!.translate(
                                TranslationKeys.findYourCountry,
                              ),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFF8C98A8).withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 35.53.h,
                    ),

                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 24.44.w,
                          right: 34.47.w,
                          bottom: 12.3.h,
                          top: 15.03.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0.r,
                            ),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0.w,
                          ),
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          TranslationKeys.password,
                        ),
                        labelStyle: CustomizedTheme.b_W400_12,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10.0.r,
                            ),
                          ),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            'assets/svg/eye.svg',
                            color: _obscureText
                                ? Colors.black
                                : Colors.black.withOpacity(
                                    .3,
                                  ),
                          ),
                          onPressed: () {
                            _toggle();
                          },
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 10) {
                          return AppLocalizations.of(context)!.translate(
                            TranslationKeys.passwordShouldContain10Characters,
                          );
                        }
                        return null;
                      },
                    ),
                    verticalSpacer(10),
                    Row(
                      children: [
                        Checkbox(
                          value: termsAndCondition,
                          onChanged: (value) {
                            termsAndCondition = value!;
                            setState(() {});
                          },
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.translate(
                                  TranslationKeys.iAccept,
                                ),
                                style: CustomizedTheme.b_W400_12.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const TextSpan(
                                text: '  ',
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.translate(
                                  TranslationKeys.terms_Conditions,
                                ),
                                style: CustomizedTheme.b_W400_12.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CustomizedTheme.colorAccent,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    verticalSpacer(30),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 61.07.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          7.r,
                        ),
                        color: CustomizedTheme.colorAccent,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (Utils.registerFormKey.currentState!.validate() &&
                              termsAndCondition) {
                            Navigator.pushNamed(
                              context,
                              '/ScanIDPage',
                              arguments: RegisterFirst(
                                firstName: fnameController.text,
                                lastName: lnameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                areaCode: currentAreaCode,
                                phone: phoneController.text,
                                nationality: currentNationality.text,
                                nationalityId: getNationalityId(countryISO),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.translate(
                                    TranslationKeys
                                        .youHaveToAcceptTermAndConditions,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: CustomizedTheme.w_W500_15.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: CustomizedTheme.white,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                backgroundColor: CustomizedTheme.voucherUnpaid,
                              ),
                            );
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            TranslationKeys.next,
                          ),
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
    );
  }

  void getCountries(List<CountryDetails> countries) {
    if (countries.isNotEmpty) {
      for (var element in countries) {
        localCountries.add(element.iso);
      }
    }
  }

  getNationalityId(String iso) {
    if (countryISO.isNotEmpty) {
      int index = localCountries.indexWhere((element) => element == iso);
      return countriesController.countries[index].id;
    }
    return 1;
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
