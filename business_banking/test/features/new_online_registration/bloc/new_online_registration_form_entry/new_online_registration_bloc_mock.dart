import 'package:business_banking/features/new_online_registration_form/bloc/new_online_registration_bloc.dart';
import 'package:business_banking/features/new_online_registration_form/bloc/new_online_registration_form_entry/new_online_registration_event.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_form_entry/new_online_registration_enums.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_form_entry/new_online_registration_view_model.dart';
import 'package:business_banking/features/new_online_registration_form/model/new_online_registration_success/new_online_registration_success_view_model.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:mockito/mockito.dart';

class NewOnlineRegistrationBlocMock extends Mock
    implements NewOnlineRegistrationBloc {
  @override
  final newOnlineRegistrationEventsPipe =
      Pipe<NewOnlineRegistrationEvent>(canSendDuplicateData: true);
  @override
  final newOnlineRegistrationViewModelPipe =
      Pipe<NewOnlineRegistrationViewModel>();
  @override
  final newOnlineRegistrationSuccessViewModelPipe =
      Pipe<NewOnlineRegistrationRequestSuccessViewModel>();

  NewOnlineRegistrationViewModel onlineRegistrationViewModelSample =
      NewOnlineRegistrationViewModel(
    cardHolderName: 'Tyler',
    cardNumber: '378282246310005',
    validThru: '08/10',
    email: 'test@test.com',
    userPassword: 'TestPassword@123',
    cardHolderNameStatus: '',
    cardNumberStatus: '',
    cardExpiryDateStatus: '',
    userEmailStatus: '',
    userPasswordStatus: '',
  );

  NewOnlineRegistrationRequestSuccessViewModel
      onlineRegistrationSuccessViewModelSample =
      NewOnlineRegistrationRequestSuccessViewModel(
          cardHolderName: 'Tyler',
          cardNumber: '378282246310005',
          validThru: '08/50',
          email: 'test@test.com',
          userPassword: 'TestPassword@123',
          accountNumberGenerated: '123456789',
          serviceResponseStatus:
              NewOnlineRegistrationServiceResponseStatus.unknown);

  NewOnlineRegistrationBlocMock() {
    newOnlineRegistrationViewModelPipe.whenListenedDo(() {
      newOnlineRegistrationViewModelPipe.send(
        onlineRegistrationViewModelSample,
      );
    });

    newOnlineRegistrationSuccessViewModelPipe.whenListenedDo(() {
      newOnlineRegistrationSuccessViewModelPipe.send(
        onlineRegistrationSuccessViewModelSample,
      );
    });
  }
}
