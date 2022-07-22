import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  InAppPurchase? _inAppPurchase;

  InAppPurchaseService() {
    _inAppPurchase = InAppPurchase.instance;
  }

  Future<List<ProductDetails>?> getProductsDetails(Set<String> productIds) async {
    final isStoreAvailable = await _inAppPurchase?.isAvailable();

    if (isStoreAvailable == false) return [];

    final response = await _inAppPurchase?.queryProductDetails(productIds);

    if (response?.productDetails.isEmpty == true) return [];

    return response?.productDetails;
  }
}
