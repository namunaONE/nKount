import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nkount/core/constants/app_constants.dart';
import 'package:nkount/core/database/hive_service.dart';
import 'package:nkount/core/models/product_model.dart';
import 'package:nkount/packages/design-system/design_system.dart';

/// Products Screen with Claymorphism Design
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    
    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Products'),
        actions: [
          ClayIconButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search Products',
          ),
          ClayIconButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
          ClayButton(
            onPressed: () => _showAddProductDialog(context),
            child: const Text('Add Product'),
          ),
        ],
      ),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (productList) {
          if (productList.isEmpty) {
            return const _EmptyProductsState();
          }
          return _ProductsList(products: productList);
        },
      ),
      bottomNavigationBar: ClayBottomNavigation(
        currentIndex: 2,
        items: const [
          ClayBottomNavItem(icon: Icons.dashboard, label: 'Dashboard', route: '/'),
          ClayBottomNavItem(icon: Icons.people, label: 'Contacts', route: '/contacts'),
          ClayBottomNavItem(icon: Icons.inventory, label: 'Products', route: '/products'),
          ClayBottomNavItem(icon: Icons.receipt, label: 'Transactions', route: '/transactions'),
          ClayBottomNavItem(icon: Icons.payment, label: 'Payments', route: '/payments'),
        ],
        onTap: (index) {
          final routes = ['/', '/contacts', '/products', '/transactions', '/payments'];
          if (index < routes.length) {
            context.go(routes[index]);
          }
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Search Products'),
        content: const ClaySearchInput(hintText: 'Search by name, code, or barcode'),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Filter Products'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayRadioListTile<String>(
              title: const Text('All'),
              value: 'all',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('In Stock'),
              value: 'in_stock',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Low Stock'),
              value: 'low_stock',
              groupValue: 'all',
              onChanged: (value) {},
            ),
            ClayRadioListTile<String>(
              title: const Text('Out of Stock'),
              value: 'out_of_stock',
              groupValue: 'all',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayFormDialog(
        title: const Text('Add New Product'),
        child: const _AddProductForm(),
      ),
    );
  }
}

/// Empty Products State
class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first product to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ClayButton(
            onPressed: () => context.push('/products'),
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}

/// Products List
class _ProductsList extends ConsumerWidget {
  final List<ProductModel> products;

  const _ProductsList({required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductItem(product: product);
      },
    );
  }
}

/// Product Item
class _ProductItem extends StatelessWidget {
  final ProductModel product;

  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      onTap: () => _showProductDetailDialog(context, product),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: product.inStock ? ClayColors.success.withOpacity(0.1) : ClayColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              product.inStock ? Icons.check_circle : Icons.remove_circle,
              color: product.inStock ? ClayColors.success : ClayColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Code: ${product.code ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${product.quantity.toStringAsFixed(2)} ${product.unit ?? ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: product.belowMinimum ? ClayColors.error : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'NPR ${product.salePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ClayColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 11,
                  color: product.isActive ? ClayColors.success : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProductDetailDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductDetailRow(
                icon: Icons.code,
                label: 'Product Code',
                value: product.code ?? 'N/A',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.barcode,
                label: 'Barcode',
                value: product.barcode ?? 'N/A',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.category,
                label: 'Category',
                value: product.category ?? 'N/A',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.branding_watermark,
                label: 'Brand',
                value: product.brand ?? 'N/A',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.measuring_tape,
                label: 'Unit',
                value: product.unit ?? 'N/A',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.money,
                label: 'Purchase Price',
                value: 'NPR ${product.purchasePrice.toStringAsFixed(2)}',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.money,
                label: 'Sale Price',
                value: 'NPR ${product.salePrice.toStringAsFixed(2)}',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.money,
                label: 'Cost Price',
                value: 'NPR ${product.costPrice.toStringAsFixed(2)}',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.inventory,
                label: 'Stock Quantity',
                value: '${product.quantity.toStringAsFixed(2)} ${product.unit ?? ''}',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.warning,
                label: 'Minimum Quantity',
                value: product.minQuantity.toStringAsFixed(2),
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.percent,
                label: 'Tax Rate',
                value: '${product.taxRate}%',
              ),
              const Divider(),
              _ProductDetailRow(
                icon: Icons.description,
                label: 'Description',
                value: product.description ?? 'N/A',
              ),
            ],
          ),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ClayButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

/// Product Detail Row
class _ProductDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProductDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Add Product Form
class _AddProductForm extends ConsumerStatefulWidget {
  const _AddProductForm();

  @override
  ConsumerState<_AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends ConsumerState<_AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _code = '';
  String _barcode = '';
  String _category = '';
  String _brand = '';
  String _unit = 'Unit';
  double _purchasePrice = 0.0;
  double _salePrice = 0.0;
  double _costPrice = 0.0;
  double _quantity = 0.0;
  double _minQuantity = 0.0;
  bool _isTaxable = true;
  double _taxRate = 13.0;
  String _description = '';
  String? _supplierId;
  bool _isActive = true;
  String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClayInputWithLabel(
              label: 'Product Name *',
              hintText: 'Enter product name',
              value: _name,
              onChanged: (value) => _name = value,
              validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'Product Code',
                    hintText: 'Product code',
                    value: _code,
                    onChanged: (value) => _code = value,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'Barcode',
                    hintText: 'Barcode',
                    value: _barcode,
                    onChanged: (value) => _barcode = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'Category',
                    hintText: 'Category',
                    value: _category,
                    onChanged: (value) => _category = value,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'Brand',
                    hintText: 'Brand',
                    value: _brand,
                    onChanged: (value) => _brand = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Unit',
              hintText: 'Unit of measurement',
              value: _unit,
              onChanged: (value) => _unit = value,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayCurrencyInput(
                    label: 'Purchase Price',
                    hintText: 'Purchase price',
                    value: _purchasePrice,
                    onChanged: (value) => _purchasePrice = value,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayCurrencyInput(
                    label: 'Sale Price *',
                    hintText: 'Sale price',
                    value: _salePrice,
                    onChanged: (value) => _salePrice = value,
                    validator: (value) => value == null || value <= 0 ? 'Sale price is required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClayCurrencyInput(
              label: 'Cost Price',
              hintText: 'Cost price',
              value: _costPrice,
              onChanged: (value) => _costPrice = value,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'Quantity',
                    hintText: 'Stock quantity',
                    value: _quantity.toString(),
                    onChanged: (value) => _quantity = double.tryParse(value) ?? 0.0,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'Min Quantity',
                    hintText: 'Minimum quantity',
                    value: _minQuantity.toString(),
                    onChanged: (value) => _minQuantity = double.tryParse(value) ?? 0.0,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClaySwitchInput(
                    label: 'Taxable',
                    value: _isTaxable,
                    onChanged: (value) => setState(() => _isTaxable = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClayInputWithLabel(
                    label: 'Tax Rate %',
                    hintText: 'Tax rate',
                    value: _taxRate.toString(),
                    onChanged: (value) => _taxRate = double.tryParse(value) ?? 13.0,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClayInputWithLabel(
              label: 'Description',
              hintText: 'Product description',
              value: _description,
              onChanged: (value) => _description = value,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ClaySwitchInput(
              label: 'Active',
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider for products
final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.productsBox.values.toList();
});
