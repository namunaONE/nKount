import '../../shared/transaction_flow.dart';

/// Purchases Screen for managing purchase transactions
class PurchasesScreen extends TransactionFlowScreen {
  const PurchasesScreen({super.key})
      : super(config: TransactionFlowConfig.purchase);
}
