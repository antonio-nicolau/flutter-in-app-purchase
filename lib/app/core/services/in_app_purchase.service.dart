// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_flutter/app/core/constants/constants.dart';
import 'package:in_app_purchase_flutter/app/core/models/product.model.dart';
import 'package:in_app_purchase_flutter/app/core/services/interfaces/in_app_purchase.service.interface.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

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
    PurchaseParam? purchaseParam;

    try {
      if (Platform.isAndroid) {
        GooglePlayPurchaseDetails? oldSubscription;

        if (product.productType == ProductType.subscription) {
          oldSubscription = _getOldSubscription(productDetails, <String, PurchaseDetails>{});
        }

        purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: packageName,
          changeSubscriptionParam: oldSubscription != null
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  prorationMode: ProrationMode.immediateWithTimeProration,
                )
              : null,
        );
      } else if (Platform.isIOS) {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
          applicationUserName: packageName,
        );
      }

      if (purchaseParam != null) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        return true;
      }
    } on PlatformException catch (e) {
      log('Error making ${Platform.isAndroid ? 'Android' : 'IOS'} purchase:$e');
      if (Platform.isIOS) await _finishIncompleteIosTransations();
      return false;
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  Future<bool> restorePurchase() async {
    try {
      await _inAppPurchase.restorePurchases(applicationUserName: packageName);
      return true;
    } catch (e) {
      return false;
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails productDetails, Map<String, PurchaseDetails>? purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you get your old subscription id from your backend or somewhere else
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in ItunesConnect.

    const oldSubscriptionId = 'old.subscription.teste';

    if (purchases?.containsKey(oldSubscriptionId) == true) {
      return purchases?[oldSubscriptionId] as GooglePlayPurchaseDetails;
    }
    return null;
  }
}

Future<void> _finishIncompleteIosTransations() async {
  final transactions = await SKPaymentQueueWrapper().transactions();
  for (final skPaymentTransactionWrapper in transactions) {
    skPaymentTransactionWrapper.payment.productIdentifier;
    SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
    log('finishing imcompleted IOS transation');
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
