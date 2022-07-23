import 'package:flutter/material.dart';
import 'package:in_app_purchase_flutter/app/features/home/widgets/buy_button.widget.dart';
import 'package:in_app_purchase_flutter/app/core/models/product.model.dart';
import 'package:in_app_purchase_flutter/app/features/home/widgets/restore_purchase_button.widget.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      product.productType.name,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  BuyButton(product),
                  const SizedBox(width: 15),
                  const RestorePurchaseButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
