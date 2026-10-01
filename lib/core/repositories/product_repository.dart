import 'package:hive/hive.dart';
import 'package:nkount/core/models/product_model.dart';

/// Repository for managing products
class ProductRepository {
  final Box<ProductModel> _productsBox;

  ProductRepository(this._productsBox);

  /// Get all products
  List<ProductModel> getAllProducts() {
    return _productsBox.values.toList();
  }

  /// Get product by ID
  ProductModel? getProductById(String id) {
    return _productsBox.get(id);
  }

  /// Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    return _productsBox.values
        .where((product) => product.category == category)
        .toList();
  }

  /// Search products
  List<ProductModel> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _productsBox.values
        .where((product) => 
          product.name.toLowerCase().contains(lowerQuery) ||
          product.code?.toLowerCase().contains(lowerQuery) ?? false ||
          product.barcode?.contains(query) ?? false ||
          (product.description?.toLowerCase().contains(lowerQuery) ?? false)
        )
        .toList();
  }

  /// Get products by supplier
  List<ProductModel> getProductsBySupplier(String supplierId) {
    return _productsBox.values
        .where((product) => product.supplierId == supplierId)
        .toList();
  }

  /// Get low stock products
  List<ProductModel> getLowStockProducts() {
    return _productsBox.values
        .where((product) => product.belowMinimum)
        .toList();
  }

  /// Get out of stock products
  List<ProductModel> getOutOfStockProducts() {
    return _productsBox.values
        .where((product) => !product.inStock)
        .toList();
  }

  /// Save product
  Future<ProductModel> saveProduct(ProductModel product) async {
    await _productsBox.put(product.id, product);
    return product;
  }

  /// Update product
  Future<ProductModel> updateProduct(ProductModel product) async {
    await _productsBox.put(product.id, product);
    return product;
  }

  /// Delete product
  Future<bool> deleteProduct(String id) async {
    final product = _productsBox.get(id);
    if (product != null) {
      await _productsBox.delete(id);
      return true;
    }
    return false;
  }

  /// Delete all products
  Future<void> deleteAllProducts() async {
    await _productsBox.clear();
  }

  /// Get products count
  int getProductsCount() {
    return _productsBox.length;
  }

  /// Update product quantity
  Future<ProductModel?> updateProductQuantity(String id, double change) async {
    final product = _productsBox.get(id);
    if (product != null) {
      final newQuantity = product.quantity + change;
      if (newQuantity < 0) return null; // Cannot have negative quantity
      
      final updatedProduct = product.copyWithQuantity(newQuantity);
      await _productsBox.put(id, updatedProduct);
      return updatedProduct;
    }
    return null;
  }

  /// Get total inventory value
  double getTotalInventoryValue() {
    return _productsBox.values
        .fold(0.0, (sum, product) => sum + (product.quantity * product.costPrice));
  }

  /// Get most sold products
  List<ProductModel> getMostSoldProducts({int limit = 10}) {
    return _productsBox.values
        .toList()
        ..sort((a, b) => b.totalSold.compareTo(a.totalSold))
        .take(limit)
        .toList();
  }

  /// Get most profitable products
  List<ProductModel> getMostProfitableProducts({int limit = 10}) {
    return _productsBox.values
        .toList()
        ..sort((a, b) => b.profitMargin.compareTo(a.profitMargin))
        .take(limit)
        .toList();
  }

  /// Export products to list
  List<Map<String, dynamic>> exportProducts() {
    return _productsBox.values
        .map((product) => product.toJson())
        .toList();
  }

  /// Import products from list
  Future<int> importProducts(List<Map<String, dynamic>> productsData) async {
    int count = 0;
    for (final data in productsData) {
      try {
        final product = ProductModel.fromJson(data);
        await _productsBox.put(product.id, product);
        count++;
      } catch (e) {
        // Skip invalid products
        continue;
      }
    }
    return count;
  }
}
