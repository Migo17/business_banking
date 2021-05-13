// @dart=2.9
import 'package:business_banking/features/new_online_registration_form/api/new_online_registration_service_request_model.dart';
import 'package:business_banking/features/new_online_registration_form/api/new_online_registration_service_response_model.dart';
import 'package:business_banking/features/new_online_registration_form/bloc/new_online_registration_form_entry/new_online_registration_service_adapter.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_form_entry/new_online_registration_entity.dart';
import 'package:test/test.dart';

void main() {
  group('Online Registration service adapter test', () {
    final tEntity = NewOnlineRegistrationEntity(
        errors: [],
        cardHolderName: 'Tyler',
        cardNumber: '378282246310005',
        email: 'test@test.com',
        userPassword: 'TestPassword@123',
        accountNumberGenerated: '123456789');

    final tRequestModel = NewOnlineRegistrationServiceRequestModel(
      cardHolderName: 'Tyler',
      cardNumber: '378282246310005',
      email: 'test@test.com',
      userPassword: 'TestPassword@123',
    );

    final tJsonResponse = {
      "didSucceed": true,
      "accountNumberGenerated": "123456789"
    };

    test('should received a json response and return account number generated',
        () async {
      final entity = NewOnlineRegistrationRequestServiceAdapter().createEntity(
          NewOnlineRegistrationEntity(),
          NewOnlineRegistrationServiceResponseModel.fromJson(tJsonResponse));
      expect(entity.accountNumberGenerated, tEntity.accountNumberGenerated);
    });
    test(
        'should receive a NewOnlineRegistrationEntity and return NewOnlineRegistrationServiceRequestModel',
        () async {
      final requestModel =
          NewOnlineRegistrationRequestServiceAdapter().createRequest(tEntity);
      expect(requestModel.cardHolderName, tRequestModel.cardHolderName);
      expect(requestModel.cardNumber, tRequestModel.cardNumber);
      expect(requestModel.email, tRequestModel.email);
      expect(requestModel.userPassword, tRequestModel.userPassword);
    });
  });
}