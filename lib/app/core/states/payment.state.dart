import 'package:hooks_riverpod/hooks_riverpod.dart';

enum PaymentPurchaseStatus {
  purchased,
  pending,
  canceled,
  canceledByUser,
  error,
  none,
}

final productPurchasedStatusProvider = StateProvider.family<PaymentPurchaseStatus, String>((ref, purchaseId) {
  return PaymentPurchaseStatus.none;
});
