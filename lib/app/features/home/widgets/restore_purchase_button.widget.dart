import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase_flutter/app/core/services/in_app_purchase.service.dart';

class RestorePurchaseButton extends HookConsumerWidget {
  const RestorePurchaseButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () async {
          await ref.read(inAppPurchaseServiceprovider).restorePurchase();
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
        ),
        child: Text('Restore', style: Theme.of(context).textTheme.subtitle2));
  }
}
