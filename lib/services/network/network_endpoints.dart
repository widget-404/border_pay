class EndPoints {
  final String _baseURL = 'https://v2-border-pay.vercel.app/api';
  final String _tourist = '/tourist';
  final String _registerUser = '/register';
  final String _verifyUser = '/verify-account';
  final String _loginUser = '/login';
  final String _password = '/password';
  final String _voucherList = '/voucher/list';
  final String _company = '/tourist-company';
  final String _vouchers = '/vouchers';
  final String _voucher = '/voucher';
  final String _createVouchers = '/voucher/create';
  final String _payVouchers = '/voucher/pay';
  final String _payTransaction = '/process-transaction';
  final String _createBulkVouchers = '/voucher/create-bulk';
  final String _createVouchersTransaction = '/voucher/create-transaction';
  final String _countries = '/database/country';

  String registerUser() {
    return _baseURL + _tourist + _registerUser;
  }

  String verifyUser() {
    return _baseURL + _tourist + _verifyUser;
  }

  String logInUser() {
    return _baseURL + _tourist + _loginUser;
  }

  String changePassword(int id) {
    return _baseURL + _tourist + '/$id' + _password;
  }

  String voucherDetails(int userId, int voucherId) {
    return _baseURL + _tourist + '/$userId' + _voucher + '/$voucherId';
  }

  String voucherList(int id) {
    return _baseURL + _tourist + '/$id' + _voucherList;
  }

  String companyVoucherList(int id) {
    return _baseURL + _company + '/$id' + _vouchers;
  }

  String createVoucher(int id) {
    return _baseURL + _tourist + '/$id' + _createVouchers;
  }

  String payVoucher(int id) {
    return _baseURL + _tourist + '/$id' + _payVouchers;
  }

  String payTransaction() {
    return _baseURL + _payTransaction;
  }

  String createBulkVoucher(int id) {
    return _baseURL + _tourist + '/$id' + _createBulkVouchers;
  }

  String createVoucherTransaction(int id) {
    return _baseURL + _tourist + '/$id' + _createVouchersTransaction;
  }

  String getCountries() {
    return _baseURL + _countries;
  }
}
