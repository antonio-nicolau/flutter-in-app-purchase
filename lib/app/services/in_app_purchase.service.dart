import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_flutter/app/services/interfaces/in_app_purchase.service.interface.dart';

final inAppPurchaseServiceprovider = Provider<IInAppPurchaseService>((ref) {
  return InAppPurchaseService(InAppPurchase.instance);
});

class InAppPurchaseService implements IInAppPurchaseService {
  final InAppPurchase _inAppPurchase;

  InAppPurchaseService(this._inAppPurchase);

  @override
  Future<List<ProductDetails>?> getProductsDetails(Set<String> productIds) async {
    final isStoreAvailable = await _inAppPurchase.isAvailable();

    if (isStoreAvailable == false) return [];

    final response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.productDetails.isEmpty == true) return [];

    return response.productDetails;
  }
}
