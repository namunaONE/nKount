import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/hive_service.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/money.dart';
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
                if (sorted.isEmpty) {
                  return Center(
                    child: ClayEmptyState(
                      icon: Icons.inventory_outlined,
                      title: 'No Products Found',
                      subtitle: 'Add your first product to get started',
                      action: ClayButton(
                        onPressed: () => context.push('/products'),
                        child: const Text('Add Product'),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) =>
                      _ProductItem(product: sorted[index]),
                );
              }
              if (sorted.isEmpty) {
                return Center(
                  child: ClayEmptyState(
                    icon: Icons.inventory_outlined,
                    title: 'No Products Found',
                    subtitle: 'Add your first product to get started',
                    action: ClayButton(
                      onPressed: () => context.push('/products'),
                      child: const Text('Add Product'),
                    ),
                  ),
                );
              }
              return ClayTableCard(
                title: 'Products (${sorted.length})',
                tableTitle: 'All products',
                searchHint: 'Search...',
                onSearchChanged: (v) => setState(() => _searchQuery = v),
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (v) => setState(() => _rowsPerPage = v!),
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: Text('Name',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 0;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Code',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 1;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Category',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 2;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Stock',
                        style: Theme.of(context).textTheme.labelLarge),
                    numeric: true,
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 3;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Sale Price',
                        style: Theme.of(context).textTheme.labelLarge),
                    numeric: true,
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 4;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Status',
                        style: Theme.of(context).textTheme.labelLarge),
                    onSort: (col, asc) => setState(() {
                      _sortColumnIndex = 5;
                      _sortAscending = asc;
                    }),
                  ),
                  DataColumn(
                    label: Text('Actions',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ],
                source: _ProductsDataSource(
                  products: sorted,
                  onView: (p) => _showProductDetailDialog(context, p),
                  onDelete: (p) => _confirmDeleteProduct(context, ref, p),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: mainNavBar(context, 2),
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
    showClaySearchDialog(
      context,
      title: 'Search Products',
      hintText: 'Search by name, code, or barcode',
      onChanged: (v) => setState(() => _searchQuery = v),
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
        DataCell(Text(p.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        DataCell(Text(p.code ?? '—')),
        DataCell(Text(p.category ?? '—')),
        DataCell(Text(
          '${p.quantity.toStringAsFixed(0)} ${p.unit ?? ''}',
          style: ClayTypography.tabular(TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: low ? ClayColors.error : null,
          )),
        )),
        DataCell(Text(
          formatCurrency(p.salePrice),
          style: ClayTypography.tabular(const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          )),
        )),
        DataCell(
          Chip(
            label: Text(
              !p.isActive
                  ? 'Inactive'
                  : low
                      ? 'Low'
                      : 'OK',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5),
            ),
            backgroundColor: (!p.isActive
                    ? ClayColors.neutral
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
              icon: const Icon(ClayIcons.view, size: ClayIconSize.dense),
              onPressed: () => onView(p),
              tooltip: 'View',
            ),
            IconButton(
              icon: const Icon(ClayIcons.delete, size: ClayIconSize.dense),
              color: ClayColors.error,
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
            ClayDetailRow(
              icon: Icons.code,
              label: 'Product Code',
              value: product.code ?? 'N/A',
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.money,
              label: 'Sale Price',
              value: formatCurrency(product.salePrice),
            ),
            const Divider(),
            ClayDetailRow(
              icon: Icons.inventory,
              label: 'Stock Quantity',
              value:
                  '${product.quantity.toStringAsFixed(2)} ${product.unit ?? ''}',
            ),
            const Divider(),
            ClayDetailRow(
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
  if (await showClayConfirmDialog(
    context,
    title: 'Delete product?',
    message: 'Delete ${product.name}? Past transactions keep their history.',
  )) {
    await hiveService.productsBox.delete(product.id);
    ref.invalidate(productsProvider);
  }
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Code: ${product.code ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${product.quantity.toStringAsFixed(2)} ${product.unit ?? ''}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: product.belowMinimum
                              ? ClayColors.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(product.salePrice),
                  style: ClayTypography.tabular(
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ClayColors.primary,
                          )),
                ),
                const SizedBox(height: 4),
                Text(
                  product.isActive ? 'Active' : 'Inactive',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: product.isActive
                          ? ClayColors.success
                          : Theme.of(context).colorScheme.onSurfaceVariant),
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
              ClayDetailRow(
                icon: Icons.code,
                label: 'Product Code',
                value: product.code ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.qr_code,
                label: 'Barcode',
                value: product.barcode ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.category,
                label: 'Category',
                value: product.category ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.branding_watermark,
                label: 'Brand',
                value: product.brand ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.straighten,
                label: 'Unit',
                value: product.unit ?? 'N/A',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.money,
                label: 'Purchase Price',
                value: formatCurrency(product.purchasePrice),
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.money,
                label: 'Sale Price',
                value: formatCurrency(product.salePrice),
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.money,
                label: 'Cost Price',
                value: formatCurrency(product.costPrice),
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.inventory,
                label: 'Stock Quantity',
                value:
                    '${product.quantity.toStringAsFixed(2)} ${product.unit ?? ''}',
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.warning,
                label: 'Minimum Quantity',
                value: product.minQuantity.toStringAsFixed(2),
              ),
              const Divider(),
              ClayDetailRow(
                icon: Icons.percent,
                label: 'Tax Rate',
                value: '${product.taxRate}%',
              ),
              const Divider(),
              ClayDetailRow(
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
