import 'package:business_banking/dependency/card_scanner_plugin.dart';
import 'package:business_banking/dependency/permission_handler_plugin.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_form_entry/new_online_registration_entity.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_form_entry/new_online_registration_enums.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_form_entry/new_online_registration_view_model.dart';
import 'package:business_banking/locator.dart';
import 'package:card_scanner/card_scanner.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';

class NewOnlineRegistrationRequestUseCase extends UseCase {
  RepositoryScope? _scopeRegistrationFormEntity;

  late final PermissionHandlerPlugin _permissionHandlerPluginImpl;
  late final CardScannerPlugin _cardScannerPluginImpl;
  final ViewModelCallback<ViewModel> _viewModelCallBack;

  NewOnlineRegistrationRequestUseCase(
      ViewModelCallback<ViewModel> viewModelCallBack,
      PermissionHandlerPlugin permissionHandlerPlugin,
      CardScannerPlugin cardScannerPluginImpl)
      : _viewModelCallBack = viewModelCallBack,
        _permissionHandlerPluginImpl = permissionHandlerPlugin,
        _cardScannerPluginImpl = cardScannerPluginImpl;

  Future<void> create() async {
    _scopeRegistrationFormEntity = ExampleLocator()
        .repository
        .create<NewOnlineRegistrationEntity>(
            NewOnlineRegistrationEntity(), _notifySubscribers);
    NewOnlineRegistrationEntity newOnlineRegistrationEntity =
        ExampleLocator().repository.get(_scopeRegistrationFormEntity!);

    _notifySubscribers(newOnlineRegistrationEntity);
  }

  void _notifySubscribers(entity) {
    _viewModelCallBack(buildViewModel());
  }

  NewOnlineRegistrationViewModel buildViewModel({
    status: '',
    inputStatusType = NewOnlineRegistrationInputStatusType.unknown,
    NewOnlineRegistrationEntity? newOnlineRegistrationEntity,
  }) {
    newOnlineRegistrationEntity = newOnlineRegistrationEntity ??
        ExampleLocator().repository.get(_scopeRegistrationFormEntity!);
    if (newOnlineRegistrationEntity.hasErrors()) {
      return NewOnlineRegistrationViewModel(
        cardHolderName: newOnlineRegistrationEntity.cardHolderName,
        cardNumber: newOnlineRegistrationEntity.cardNumber,
        validThru: newOnlineRegistrationEntity.validThru,
        email: newOnlineRegistrationEntity.email,
        userPassword: newOnlineRegistrationEntity.userPassword,
        cardHolderNameStatus: inputStatusType ==
                NewOnlineRegistrationInputStatusType.cardHolderName
            ? status
            : '',
        cardNumberStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.cardNumber
                ? status
                : '',
        cardExpiryDateStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.expiryDate
                ? status
                : '',
        userEmailStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.email
                ? status
                : '',
        userPasswordStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.userPassword
                ? status
                : '',
        serviceResponseStatus:
            NewOnlineRegistrationServiceResponseStatus.failed,
      );
    } else {
      return NewOnlineRegistrationViewModel(
        cardHolderName: newOnlineRegistrationEntity.cardHolderName,
        cardNumber: newOnlineRegistrationEntity.cardNumber,
        validThru: newOnlineRegistrationEntity.validThru,
        email: newOnlineRegistrationEntity.email,
        userPassword: newOnlineRegistrationEntity.userPassword,
        cardHolderNameStatus: inputStatusType ==
                NewOnlineRegistrationInputStatusType.cardHolderName
            ? status
            : '',
        cardNumberStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.cardNumber
                ? status
                : '',
        cardExpiryDateStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.expiryDate
                ? status
                : '',
        userEmailStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.email
                ? status
                : '',
        userPasswordStatus:
            inputStatusType == NewOnlineRegistrationInputStatusType.userPassword
                ? status
                : '',
        serviceResponseStatus:
            NewOnlineRegistrationServiceResponseStatus.succeed,
      );
    }
  }

  Future<void> getCardInformation() async {
    CardDetails? result;
    var isGranted = await _permissionHandlerPluginImpl.isGrantedAccessCamera();
    if (isGranted == true) {
      result = await _cardScannerPluginImpl.scanCard();
    }
    final NewOnlineRegistrationEntity entity = ExampleLocator()
        .repository
        .get<NewOnlineRegistrationEntity>(_scopeRegistrationFormEntity!);
    if (result != null) {
      final updatedEntity = entity.merge(
          cardNumber: result.cardNumber ?? '',
          validThru: result.expiryDate ?? '');
      ExampleLocator().repository.update<NewOnlineRegistrationEntity>(
          _scopeRegistrationFormEntity!,
          updatedEntity as NewOnlineRegistrationEntity);
    }
    _viewModelCallBack(buildViewModel());
  }

  updateUserName(String userName) {
    final NewOnlineRegistrationEntity entity = ExampleLocator()
        .repository
        .get<NewOnlineRegistrationEntity>(_scopeRegistrationFormEntity!);
    final updatedEntity = entity.merge(cardHolderName: userName);
    ExampleLocator().repository.update<NewOnlineRegistrationEntity>(
        _scopeRegistrationFormEntity!,
        updatedEntity as NewOnlineRegistrationEntity);
    String? checkUserInputStatus = validateUserName(userName);
    if (checkUserInputStatus.isNotEmpty) {
      _viewModelCallBack(buildViewModel(
        status: checkUserInputStatus,
        inputStatusType: NewOnlineRegistrationInputStatusType.cardHolderName,
      ));
    } else {
      _viewModelCallBack(buildViewModel());
    }
  }

  updateCardNumber(String cardNumber) {
    final NewOnlineRegistrationEntity entity = ExampleLocator()
        .repository
        .get<NewOnlineRegistrationEntity>(_scopeRegistrationFormEntity!);
    final updatedEntity = entity.merge(cardNumber: cardNumber);
    ExampleLocator().repository.update<NewOnlineRegistrationEntity>(
        _scopeRegistrationFormEntity!,
        updatedEntity as NewOnlineRegistrationEntity);
    String? checkUserInputStatus = validateCardNumber(cardNumber);
    if (checkUserInputStatus.isNotEmpty) {
      _viewModelCallBack(buildViewModel(
        status: checkUserInputStatus,
        inputStatusType: NewOnlineRegistrationInputStatusType.cardNumber,
      ));
    } else {
      _viewModelCallBack(buildViewModel());
    }
  }

  updateCardExpireDate(String expiryDate) {
    final NewOnlineRegistrationEntity entity = ExampleLocator()
        .repository
        .get<NewOnlineRegistrationEntity>(_scopeRegistrationFormEntity!);
    final updatedEntity = entity.merge(validThru: expiryDate);
    ExampleLocator().repository.update<NewOnlineRegistrationEntity>(
        _scopeRegistrationFormEntity!,
        updatedEntity as NewOnlineRegistrationEntity);
    String? checkUserInputStatus = validateDate(expiryDate);
    if (checkUserInputStatus!.isNotEmpty) {
      _viewModelCallBack(buildViewModel(
        status: checkUserInputStatus,
        inputStatusType: NewOnlineRegistrationInputStatusType.expiryDate,
      ));
    } else {
      _viewModelCallBack(buildViewModel());
    }
  }

  updateEmailAddress(String _email) {
    final NewOnlineRegistrationEntity entity = ExampleLocator()
        .repository
        .get<NewOnlineRegistrationEntity>(_scopeRegistrationFormEntity!);
    final updatedEntity = entity.merge(email: _email);
    ExampleLocator().repository.update<NewOnlineRegistrationEntity>(
        _scopeRegistrationFormEntity!,
        updatedEntity as NewOnlineRegistrationEntity);
    String checkUserInputStatus = validateEmailAddress(_email);
    if (checkUserInputStatus.isNotEmpty) {
      _viewModelCallBack(buildViewModel(
        status: checkUserInputStatus,
        inputStatusType: NewOnlineRegistrationInputStatusType.email,
      ));
    } else {
      _viewModelCallBack(buildViewModel());
    }
  }

  updatePassword(String password) {
    final NewOnlineRegistrationEntity entity = ExampleLocator()
        .repository
        .get<NewOnlineRegistrationEntity>(_scopeRegistrationFormEntity!);
    final updatedEntity = entity.merge(userPassword: password);
    ExampleLocator().repository.update<NewOnlineRegistrationEntity>(
        _scopeRegistrationFormEntity!,
        updatedEntity as NewOnlineRegistrationEntity);
    String checkUserInputStatus = validateUserPassword(password);
    if (checkUserInputStatus.isNotEmpty) {
      _viewModelCallBack(buildViewModel(
        status: checkUserInputStatus,
        inputStatusType: NewOnlineRegistrationInputStatusType.userPassword,
      ));
    } else {
      _viewModelCallBack(buildViewModel());
    }
  }

  String validateUserName(String userName) {
    if (userName.isNotEmpty &&
        userName.contains(RegExp(r"^[a-zA-Z]*$")) == true) {
      return '';
    } else {
      return "Please provide valid name.";
    }
  }

  String validateCardNumber(String cardNumber) {
    RegExp regExp = new RegExp(r"[^0-9]");
    cardNumber = cardNumber.replaceAll(regExp, '');
    if (cardNumber.isNotEmpty &&
        cardNumber.contains(RegExp(
                r"^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$")) ==
            true) {
      return '';
    } else {
      return "Please provide valid credit card Number.";
    }
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please provide valid expiry date";
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(new RegExp(r'(/)'))) {
      var split = value.split(new RegExp(r'(/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return '';
  }

  bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  String validateEmailAddress(String userEmail) {
    if (userEmail.isNotEmpty &&
        userEmail.contains(RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")) ==
            true) {
      return '';
    } else {
      return "Please, provide a valid email.";
    }
  }

  String validateUserPassword(String password) {
    if (password.isNotEmpty &&
        password.contains(RegExp(
                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$")) ==
            true) {
      return '';
    } else {
      return "Password should be minimum eight characters, at least one uppercase letter, one lowercase letter and one number.";
    }
  }
}
