import 'package:flutter/material.dart';
import 'package:in_app_purchase_flutter/app/features/home/widgets/product_card.widget.dart';
import 'package:in_app_purchase_flutter/app/models/product.model.dart';
import 'package:in_app_purchase_flutter/app/services/in_app_purchase.service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final InAppPurchaseService inAppPurchaseService = InAppPurchaseService();

  final products = [
    Product(
      title: 'Test subscription',
      price: 34.9,
      productId: 'in.app.purchase.subscription',
      productType: ProductType.subscription,
    ),
    Product(
      title: 'Test product',
      price: 199.99,
      productId: 'in.app.purchase.product',
      productType: ProductType.product,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    inAppPurchaseService
        .getProductsDetails(<String>{'in.app.purchase.testeproduct'}).then((value) => print('Result: ${value?.first.title}'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
