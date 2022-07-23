enum ProductType { product, subscription }

class Product {
  final String title;
  final double price;
  final String productId;
  final ProductType productType;

  Product({
    required this.title,
    required this.price,
    required this.productId,
    required this.productType,
  });
}
