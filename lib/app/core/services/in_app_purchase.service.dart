// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_flutter/app/core/models/product.model.dart';
import 'package:in_app_purchase_flutter/app/core/services/interfaces/in_app_purchase.service.interface.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

final inAppPurchaseServiceprovider = Provider<IInAppPurchaseService>((ref) {
  return InAppPurchaseService(InAppPurchase.instance);
});

class InAppPurchaseService implements IInAppPurchaseService {
  final InAppPurchase _inAppPurchase;
  final String packageName = 'in.app.purchase.flutter.in_app_purchase_flutter';

  InAppPurchaseService(this._inAppPurchase);

  @override
  Future<List<ProductDetails>?> getProductsDetails(Set<String> productIds) async {
    final isStoreAvailable = await _inAppPurchase.isAvailable();

    if (isStoreAvailable == false) return [];

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(IosPaymentQueueDelegate());
    }

    final response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.productDetails.isEmpty == true) return [];

    return response.productDetails;
  }

  @override
  Future<bool> purchase(Product product, ProductDetails productDetails) async {
    late PurchaseParam purchaseParam;

    try {
      if (Platform.isAndroid) {
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: packageName,
        );
      } else {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
          applicationUserName: packageName,
        );
      }

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } on PlatformException catch (e) {
      log('Error making ${Platform.isAndroid ? 'Android' : 'IOS'} purchase:$e', name: 'InAppPurchaseService.makePurchase()');
      await _finishIncompleteIosTransations();
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _finishIncompleteIosTransations() async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (final skPaymentTransactionWrapper in transactions) {
        skPaymentTransactionWrapper.payment.productIdentifier;
        SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
        log('finishing imcompleted IOS transation');
      }
    }
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class IosPaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
