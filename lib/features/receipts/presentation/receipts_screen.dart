import '../../shared/money_flow.dart';

/// Receipts Screen with Claymorphism Design
/// This screen shows all receipts (payments received from customers)
class ReceiptsScreen extends MoneyFlowScreen {
  const ReceiptsScreen({super.key}) : super(config: MoneyFlowConfig.receipt);
}
