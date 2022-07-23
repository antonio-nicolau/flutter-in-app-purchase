import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_flutter/app/models/product.model.dart';
import 'package:in_app_purchase_flutter/app/services/in_app_purchase.service.dart';

class BuyButton extends HookConsumerWidget {
  const BuyButton(this.product, {Key? key}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productDetail = useState<ProductDetails?>(null);
    useEffect(
      () {
        Future.microtask(() async {
          final response = await ref.read(inAppPurchaseServiceprovider).getProductsDetails({product.productId});

          if (response != null && response.isNotEmpty) {
            productDetail.value = response.first;
          }
        });
        return;
      },
      [product],
    );
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Buy', style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(width: 10),
          if (productDetail.value != null)
            Text('${productDetail.value?.price}', style: Theme.of(context).textTheme.subtitle2)
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
