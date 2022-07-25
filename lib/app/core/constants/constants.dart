import 'package:in_app_purchase_flutter/app/core/models/product.model.dart';

const String packageName = 'in.app.purchase.flutter.in_app_purchase_flutter';

final products = [
  Product(
    title: 'Test subscription',
    price: 34.9,
    productId: 'in.app.purchase.testesubscription',
    productType: ProductType.subscription,
  ),
  Product(
    title: 'Test product',
    price: 199.99,
    productId: 'in.app.purchase.testeproduct',
    productType: ProductType.product,
  ),
];
