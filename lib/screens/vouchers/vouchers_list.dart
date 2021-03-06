import 'dart:convert';

import 'package:borderpay/Utils/sharedPrefKeys.dart';
import 'package:borderpay/Utils/sharedpref.dart';
import 'package:borderpay/app_theme/theme.dart';
import 'package:borderpay/model/datamodels/user_model.dart';
import 'package:borderpay/model/datamodels/voucher_model.dart';
import 'package:borderpay/repo/voucher_repo/voucher_repo.dart';
import 'package:borderpay/repo/voucher_repo/voucher_repo_impl.dart';
import 'package:borderpay/screens/home_page/my_vouchers.dart';
import 'package:borderpay/widget/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../localization/app_localization.dart';
import '../../localization/translation_keys.dart';

class VouchersPage extends StatefulWidget {
  const VouchersPage({Key? key}) : super(key: key);

  @override
  _VouchersPageState createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {
  VoucherModel companyVoucherList = VoucherModel();
  VoucherModel individualVoucherList = VoucherModel();
  VoucherRepo repo = VoucherRepoImpl();
  List<VoucherDataModel> searchCompanyResult = List.empty(growable: true);
  List<VoucherDataModel> searchIndividualResult = List.empty(growable: true);

  TextEditingController searchController = TextEditingController();
  UserModel loginData = UserModel();
  MySharedPreferences storage = MySharedPreferences.instance;

  bool isLoading = true;
  bool isError = false;
  int pageNumber = 1;
  int selector = 1;
  String searchText = '';

  @override
  void initState() {
    if (loginData.firstName.isEmpty) {
      getUserData();
    }
    getCompanyVoucherData(
      loginData.userId,
    );
    getIndividualVoucherData(
      loginData.userId,
    );
    super.initState();
  }

  void getUserData() {
    bool isUserExist = storage.containsKey(SharedPrefKeys.user);
    if (isUserExist) {
      String user = storage.getStringValue(SharedPrefKeys.user);
      loginData = UserModel.fromJson(json.decode(user)['data']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
              AppLocalizations.of(context)!.translate(
                TranslationKeys.myVouchers,
              ),
              style: CustomizedTheme.title_sf_W500_21),
        ),
      ),
      body: isLoading
          ? getLoadingScreen()
          : isError
              ? getErrorScreen()
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selector = 0;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: selector == 0
                                    ? CustomizedTheme.colorAccent
                                    : CustomizedTheme.primaryColor,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate(
                                  TranslationKeys.companyVoucher,
                                ),
                                style: CustomizedTheme.w_W300_12,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selector == 1
                                    ? CustomizedTheme.colorAccent
                                    : CustomizedTheme.primaryColor,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    selector = 1;
                                  },
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.translate(
                                  TranslationKeys.individualVoucher,
                                ),
                                style: CustomizedTheme.w_W300_12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 16.h),
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) => {
                          setState(() {
                            onSearchTextChanged(value);
                          }),
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(13),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          label: Text(
                            AppLocalizations.of(context)!.translate(
                              TranslationKeys.search,
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      height: 41.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      margin: EdgeInsets.only(
                          top: 17.35.h, left: 20.w, right: 20.w),
                      decoration: BoxDecoration(
                          color: CustomizedTheme.colorAccent,
                          borderRadius: BorderRadius.circular(6.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 80.w,
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                TranslationKeys.voucherNo,
                              ),
                              style: CustomizedTheme.roboto_w_W500_14,
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: Text(
                                AppLocalizations.of(context)!.translate(
                                  TranslationKeys.location,
                                ),
                                style: CustomizedTheme.roboto_w_W500_14),
                          ),
                          Text(
                              AppLocalizations.of(context)!.translate(
                                TranslationKeys.status,
                              ),
                              style: CustomizedTheme.roboto_w_W500_14),
                        ],
                      ),
                    ),
                    selector == 0 && companyVoucherList.data.isNotEmpty
                        ? const SizedBox.shrink()
                        : selector == 1 && individualVoucherList.data.isNotEmpty
                            ? const SizedBox.shrink()
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: .5.h,
                                        color: CustomizedTheme.colorAccent,
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 40.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.56.w, vertical: 16.h),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .translate(
                                            TranslationKeys.noTransactionYet,
                                          ),
                                          style: CustomizedTheme.sf_b_W300_14),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: .5.h,
                                        color: CustomizedTheme.colorAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    Expanded(
                      child: MyVouchers(
                        voucherList: selector == 0
                            ? searchText.isEmpty
                                ? companyVoucherList
                                : VoucherModel(data: searchCompanyResult)
                            : searchText.isEmpty
                                ? individualVoucherList
                                : VoucherModel(data: searchIndividualResult),
                        loadMoreData: () {
                          if (selector == 0 &&
                              searchText.isEmpty &&
                              !companyVoucherList.lastPage) {
                            loadMoreData(
                              companyVoucherList.page,
                            );
                          } else if (selector != 0 &&
                              searchText.isEmpty &&
                              !individualVoucherList.lastPage) {
                            loadMoreData(
                              individualVoucherList.page,
                            );
                          }
                        },
                        lastPage: selector == 0
                            ? searchText.isEmpty
                                ? companyVoucherList.lastPage
                                : true
                            : searchText.isEmpty
                                ? individualVoucherList.lastPage
                                : true,
                      ),
                    ),
                    verticalSpacer(32),
                  ],
                ),
    );
  }

  Future<void> getCompanyVoucherData(int id) async {
    var response = await repo.getCompanyVoucherList(id);
    if (response != null) {
      companyVoucherList = response;
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  Future<void> getIndividualVoucherData(int id) async {
    var response = await repo.getVoucherList(
      id: id,
    );
    if (response != null) {
      individualVoucherList = response;
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  Widget getLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getErrorScreen() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.translate(
              TranslationKeys.noDataFound,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(100.w, 20.h),
              primary: CustomizedTheme.colorAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
                isError = false;
              });
              if (loginData.firstName.isEmpty) {
                getUserData();
              }
              getCompanyVoucherData(
                loginData.userId,
              );
              getIndividualVoucherData(
                loginData.userId,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.translate(
                TranslationKeys.retry,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String value) {
    searchText = value;
    searchCompanyResult.clear();
    searchIndividualResult.clear();
    if (value.isNotEmpty) {
      companyVoucherList.data.forEach((element) {
        if (element.location.title
                .toUpperCase()
                .contains(value.toUpperCase()) ||
            element.status.toUpperCase().contains(value.toUpperCase()) ||
            element.voucherNumber.toUpperCase().contains(value.toUpperCase())) {
          searchCompanyResult.add(element);
        }
      });
      individualVoucherList.data.forEach((element) {
        if (element.location.title
                .toUpperCase()
                .contains(value.toUpperCase()) ||
            element.status.toUpperCase().contains(value.toUpperCase()) ||
            element.voucherNumber.toUpperCase().contains(value.toUpperCase())) {
          searchIndividualResult.add(element);
        }
      });
    }
    setState(() {});
  }

  Future<void> loadMoreData(int page) async {
    VoucherRepo repo = VoucherRepoImpl();
    var response = await repo.getVoucherList(
      id: loginData.userId,
      page:
          selector == 0 ? companyVoucherList.page : individualVoucherList.page,
    );
    if (response != null) {
      VoucherModel model = response;
      if (selector == 0) {
        companyVoucherList.lastPage = model.lastPage;
        companyVoucherList.page = model.page;
        for (int i = 0; i < model.data.length; i++) {
          companyVoucherList.data.add(model.data[i]);
        }
      } else {
        individualVoucherList.lastPage = model.lastPage;
        individualVoucherList.page = model.page;
        for (int i = 0; i < model.data.length; i++) {
          individualVoucherList.data.add(model.data[i]);
        }
      }

      setState(() {});
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }
}
