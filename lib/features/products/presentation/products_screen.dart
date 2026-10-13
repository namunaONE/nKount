import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/product_model.dart';
import '../../../packages/design-system/design_system.dart';

/// Products Screen: dense sortable table (desktop) + cards (mobile).
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _searchQuery = '';
  String _selectedStock = 'all';
  int _rowsPerPage = 25;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);

    return ClayScaffold(
      appBar: ClayAppBar(
        title: const Text('Products'),
        subtitle: const Text('Inventory, pricing, stock levels'),
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
          final filtered = _filterProducts(productList);
          final sorted = _sortProducts(filtered);
          return LayoutBuilder(
            builder: (context, constraints) {
              if (ClayBreakpoints.isCompact(constraints.maxWidth)) {
                if (sorted.isEmpty) return const _EmptyProductsState();
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) =>
                      _ProductItem(product: sorted[index]),
                );
              }
              if (sorted.isEmpty) return const _EmptyProductsState();
              return SizedBox(
                height: constraints.maxHeight,
                child: Card(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Products (${sorted.length})',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 280,
                              child: ClaySearchInput(
                                hintText: 'Search...',
                                onChanged: (v) =>
                                    setState(() => _searchQuery = v),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          child: PaginatedDataTable(
                            header: const Text(
                              'All products',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            rowsPerPage: _rowsPerPage,
                            availableRowsPerPage: const [10, 25, 50, 100],
                            onRowsPerPageChanged: (v) =>
                                setState(() => _rowsPerPage = v!),
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            showCheckboxColumn: false,
                            columns: [
                              DataColumn(
                                label: const Text('Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 0;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Code',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 1;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Category',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 2;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Stock',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                numeric: true,
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 3;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Sale Price',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                numeric: true,
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 4;
                                  _sortAscending = asc;
                                }),
                              ),
                              DataColumn(
                                label: const Text('Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: (col, asc) => setState(() {
                                  _sortColumnIndex = 5;
                                  _sortAscending = asc;
                                }),
                              ),
                              const DataColumn(
                                label: Text('Actions',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                            source: _ProductsDataSource(
                              products: sorted,
                              onView: (p) =>
                                  _showProductDetailDialog(context, p),
                              onDelete: (p) =>
                                  _confirmDeleteProduct(context, ref, p),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ClayBottomNavigation(
        currentIndex: 2,
        items: const [
          ClayBottomNavItem(
              icon: Icons.dashboard, label: 'Dashboard', route: '/'),
          ClayBottomNavItem(
              icon: Icons.people, label: 'Contacts', route: '/contacts'),
          ClayBottomNavItem(
              icon: Icons.inventory, label: 'Products', route: '/products'),
          ClayBottomNavItem(
              icon: Icons.receipt,
              label: 'Transactions',
              route: '/transactions'),
          ClayBottomNavItem(
              icon: Icons.payment, label: 'Payments', route: '/payments'),
        ],
        onTap: (index) {
          final routes = [
            '/',
            '/contacts',
            '/products',
            '/transactions',
            '/payments'
          ];
          if (index < routes.length) {
            context.go(routes[index]);
          }
        },
      ),
    );
  }

  List<ProductModel> _filterProducts(List<ProductModel> list) =>
      list.where((p) {
        switch (_selectedStock) {
          case 'in_stock':
            if (!p.inStock) return false;
          case 'low_stock':
            if (!(p.belowMinimum && p.inStock)) return false;
          case 'out_of_stock':
            if (p.inStock) return false;
        }
        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          if (!p.name.toLowerCase().contains(q) &&
              !(p.code?.toLowerCase().contains(q) ?? false) &&
              !(p.barcode?.contains(_searchQuery) ?? false)) {
            return false;
          }
        }
        return p.isActive;
      }).toList();

  List<ProductModel> _sortProducts(List<ProductModel> list) {
    list.sort((a, b) {
      var cmp = 0;
      switch (_sortColumnIndex) {
        case 0:
          cmp = a.name.compareTo(b.name);
          break;
        case 1:
          cmp = (a.code ?? '').compareTo(b.code ?? '');
          break;
        case 2:
          cmp = (a.category ?? '').compareTo(b.category ?? '');
          break;
        case 3:
          cmp = a.quantity.compareTo(b.quantity);
          break;
        case 4:
          cmp = a.salePrice.compareTo(b.salePrice);
          break;
        case 5:
          cmp = (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0);
          break;
      }
      return _sortAscending ? cmp : -cmp;
    });
    return list;
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Search Products'),
        content: ClaySearchInput(
          hintText: 'Search by name, code, or barcode',
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    var selected = _selectedStock;
    showDialog(
      context: context,
      builder: (context) => ClayDialog(
        title: const Text('Filter Products'),
        content: SizedBox(
          width: 300,
          child: ClayDropdownInput<String>(
            label: 'Stock',
            value: selected,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'in_stock', child: Text('In Stock')),
              DropdownMenuItem(value: 'low_stock', child: Text('Low Stock')),
              DropdownMenuItem(
                  value: 'out_of_stock', child: Text('Out of Stock')),
            ],
            onChanged: (v) => selected = v!,
          ),
        ),
        actions: [
          ClayButton.text(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ClayButton(
            onPressed: () {
              setState(() => _selectedStock = selected);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ClayFormDialog(
        title: Text('Add New Product'),
        child: _AddProductForm(),
      ),
    );
  }
}

/// Table data source for products.
class _ProductsDataSource extends DataTableSource {
  _ProductsDataSource({
    required this.products,
    required this.onView,
    required this.onDelete,
  });
  final List<ProductModel> products;
  final void Function(ProductModel) onView;
  final void Function(ProductModel) onDelete;

  @override
  DataRow? getRow(int index) {
    final p = products[index];
    final low = p.belowMinimum;
    return DataRow(
      onSelectChanged: (_) => onView(p),
      cells: [
        DataCell(
            Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(p.code ?? '—')),
        DataCell(Text(p.category ?? '—')),
        DataCell(Text(
          '${p.quantity.toStringAsFixed(0)} ${p.unit ?? ''}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: low ? ClayColors.error : null,
          ),
        )),
        DataCell(Text(
          'NPR ${p.salePrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(
          Chip(
            label: Text(
              !p.isActive
                  ? 'Inactive'
                  : low
                      ? 'Low'
                      : 'OK',
              style: const TextStyle(fontSize: 11),
            ),
            backgroundColor: (!p.isActive
                    ? Colors.grey
                    : low
                        ? ClayColors.error
                        : ClayColors.success)
                .withValues(alpha: 0.1),
            visualDensity: VisualDensity.compact,
          ),
        ),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, size: 18),
              onPressed: () => onView(p),
              tooltip: 'View',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              color: Colors.red,
              onPressed: () => onDelete(p),
              tooltip: 'Delete',
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => products.length;
  @override
  int get selectedRowCount => 0;
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
              icon: Icons.money,
              label: 'Sale Price',
              value: 'NPR ${product.salePrice.toStringAsFixed(2)}',
            ),
            const Divider(),
            _ProductDetailRow(
              icon: Icons.inventory,
              label: 'Stock Quantity',
              value:
                  '${product.quantity.toStringAsFixed(2)} ${product.unit ?? ''}',
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
      ],
    ),
  );
}

Future<void> _confirmDeleteProduct(
    BuildContext context, WidgetRef ref, ProductModel product) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete product?'),
      content:
          Text('Delete ${product.name}? Past transactions keep their history.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed ?? false) {
    await hiveService.productsBox.delete(product.id);
    ref.invalidate(productsProvider);
  }
}

/// Empty Products State
class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) => Center(
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

/// Product Item (mobile card)
class _ProductItem extends StatelessWidget {
  const _ProductItem({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) => ClayCard(
        onTap: () => _showProductDetailDialog(context, product),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: product.inStock
                    ? ClayColors.success.withValues(alpha: 0.1)
                    : ClayColors.error.withValues(alpha: 0.1),
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
                      color: product.belowMinimum
                          ? ClayColors.error
                          : Colors.grey.shade600,
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
                icon: Icons.qr_code,
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
                icon: Icons.straighten,
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
                value:
                    '${product.quantity.toStringAsFixed(2)} ${product.unit ?? ''}',
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
  const _ProductDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
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
  bool _isActive = true;

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClayInputWithLabel(
                label: 'Product Name *',
                hintText: 'Enter product name',
                value: _name,
                onChanged: (value) => _name = value,
                validator: (value) =>
                    value?.isEmpty ?? false ? 'Name is required' : null,
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
                      onChanged: (value) => _purchasePrice = value ?? 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayCurrencyInput(
                      label: 'Sale Price *',
                      hintText: 'Sale price',
                      value: _salePrice,
                      onChanged: (value) => _salePrice = value ?? 0,
                      validator: (value) => value == null || value <= 0
                          ? 'Sale price is required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClayCurrencyInput(
                label: 'Cost Price',
                hintText: 'Cost price',
                value: _costPrice,
                onChanged: (value) => _costPrice = value ?? 0,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'Quantity',
                      hintText: 'Stock quantity',
                      value: _quantity.toString(),
                      onChanged: (value) =>
                          _quantity = double.tryParse(value) ?? 0.0,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ClayInputWithLabel(
                      label: 'Min Quantity',
                      hintText: 'Minimum quantity',
                      value: _minQuantity.toString(),
                      onChanged: (value) =>
                          _minQuantity = double.tryParse(value) ?? 0.0,
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
                      onChanged: (value) =>
                          _taxRate = double.tryParse(value) ?? 13.0,
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

/// Provider for products
final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.productsBox.values.toList();
});
