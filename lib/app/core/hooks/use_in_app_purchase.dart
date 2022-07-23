// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase_flutter/app/core/states/payment.state.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void useInAppPurchaseController(WidgetRef ref) {
  return use(_UseInAppPurchaseHook(ref));
}

class _UseInAppPurchaseHook extends Hook<void> {
  const _UseInAppPurchaseHook(this.ref);

  final WidgetRef ref;

  @override
  HookState<void, Hook<void>> createState() => _UseInAppPurchaseHookState();
}

class _UseInAppPurchaseHookState extends HookState<void, _UseInAppPurchaseHook> {
  late InAppPurchase _inAppPurchase;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initHook() {
    _inAppPurchase = InAppPurchase.instance;

    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (Object error) {},
    );

    super.initHook();
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        updatePurchaseStatus(purchaseDetails, PaymentPurchaseStatus.pending);
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.canceled) {
          updatePurchaseStatus(purchaseDetails, PaymentPurchaseStatus.canceled);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
          updatePurchaseStatus(purchaseDetails, PaymentPurchaseStatus.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await verifyPurchase(purchaseDetails);

          if (valid) {
            if (purchaseDetails.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(purchaseDetails);
            }

            deliverProduct(purchaseDetails);
            updatePurchaseStatus(purchaseDetails, PaymentPurchaseStatus.purchased);
          } else {
            handleInvalidPurchase(purchaseDetails);
          }
        }
      }
    }
  }

  void showPendingUI() {}

  /// Deliver product: refresh user token or other operation
  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    log('delivering product');
  }

  /// handle error while purchasing/store side
  void handleError(IAPError? error) {
    log('Error purchasing : ${error?.message}');
  }

  /// IMPORTANT!! Always verify a purchase before delivering the product.
  /// For the purpose of an example, we directly return true but always verify it on backend
  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    log('verifying purchase');
    return Future<bool>.value(true);
  }

  /// handle invalid purchase here if  `_verifyPurchase` failed.
  void handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    log('invalid purchase');
  }

  void updatePurchaseStatus(PurchaseDetails purchaseDetails, PaymentPurchaseStatus status) {
    hook.ref.read(productPurchasedStatusProvider(purchaseDetails.productID).state).state = status;
  }

  @override
  void build(BuildContext context) {
    return;
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }

    _subscription.cancel();
    super.dispose();
  }
}
