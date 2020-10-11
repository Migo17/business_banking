import 'package:business_banking/features/transfer_funds/bloc/transfer_service_adapter.dart';
import 'package:business_banking/features/transfer_funds/enums.dart';
import 'package:business_banking/features/transfer_funds/model/transfer_confirmation_view_model.dart';
import 'package:business_banking/features/transfer_funds/model/transfer_entity.dart';
import 'package:business_banking/locator.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';

class TransferConfirmationUseCase extends UseCase {
  Function(ViewModel) _viewModelCallBack;
  RepositoryScope _scope;

  TransferConfirmationUseCase(Function(ViewModel) viewModelCallBack)
      : assert(viewModelCallBack != null),
        _viewModelCallBack = viewModelCallBack;

  Future<void> create() async {
    _scope = ExampleLocator().repository.containsScope<TransferFundsEntity>();
    if (_scope == null) {
      TransferFundsEntity newTransferEntity = new TransferFundsEntity();
      _scope = ExampleLocator()
          .repository
          .create<TransferFundsEntity>(newTransferEntity, _notifyTransferSubscribers);
    } else {
      _scope.subscription = _notifyTransferSubscribers;
    }
    // await submitTransfer();
    final entity = ExampleLocator().repository.get<TransferFundsEntity>(_scope);
    _viewModelCallBack(buildViewModelForServiceUpdate(entity));
  }

  void _notifyTransferSubscribers(entity) {
    _viewModelCallBack(buildViewModelForServiceUpdate(entity));
  }

  TransferConfirmationViewModel buildViewModelForServiceUpdate(TransferFundsEntity entity) {
    if (entity.hasErrors()) {
      return TransferConfirmationViewModel(
          fromAccount: entity.fromAccount,
          toAccount: entity.toAccount,
          amount: entity.amount,
          date: entity.date,
          serviceStatus: ServiceStatus.fail);
    } else {
      return TransferConfirmationViewModel(
          fromAccount: entity.fromAccount,
          toAccount: entity.toAccount,
          amount: entity.amount,
          date: entity.date,
          id: entity.id,
          serviceStatus: ServiceStatus.success);
    }
  }

  TransferConfirmationViewModel buildViewModelForLocalUpdateWithError(TransferFundsEntity entity) {
    return TransferConfirmationViewModel(
        fromAccount: entity.fromAccount,
        toAccount: entity.toAccount,
        amount: entity.amount,
        date: entity.date,
        id: entity.id,
        dataStatus: DataStatus.invalid);
  }

  // void submitTransfer() async {
  //   final entity = ExampleLocator().repository.get<TransferFundsEntity>(_scope);
  //   if (entity.fromAccount != null && entity.toAccount != null && entity.amount > 0) {
  //     await ExampleLocator()
  //         .repository
  //         .runServiceAdapter(_scope, TransferFundsServiceAdapter());
  //   }
  //   else {
  //     _viewModelCallBack(buildViewModelForLocalUpdateWithError(entity));
  //   }
  // }

  void clearTransferData() {
    // TODO
  }
}