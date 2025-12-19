import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'product_form_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _barcodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    final listToShow = provider.searchedProduct != null
        ? [provider.searchedProduct!]
        : provider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode App'),
        actions: [
          IconButton(
            tooltip: 'Add',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const ProductFormDialog(),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => provider.loadProducts(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Barcode No',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final barcode = _barcodeCtrl.text.trim();

                      if (barcode.isEmpty) {
                        _showMsg(context, 'Barcode boş olamaz.');
                        return;
                      }

                      final p = await provider.searchByBarcode(barcode);
                      if (!mounted) return;

                      if (p == null) {
                        _showNotFoundDialog(context, barcode);
                      }
                    },
                    child: const Text('Search'),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      _barcodeCtrl.clear();
                      provider.loadProducts();
                    },
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: listToShow.isEmpty
                  ? const Center(child: Text('No products'))
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Barcode')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('UnitPrice')),
                    DataColumn(label: Text('TaxRate')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: listToShow.map((p) {
                    return DataRow(
                      cells: [
                        DataCell(Text(p.barcodeNo)),
                        DataCell(Text(p.productName)),
                        DataCell(Text(p.category)),
                        DataCell(Text(p.unitPrice.toStringAsFixed(2))),
                        DataCell(Text('${p.taxRate}%')),
                        DataCell(Text(p.price.toStringAsFixed(2))),
                        DataCell(Text(p.stockInfo?.toString() ?? 'N/A')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        ProductFormDialog(initial: p),
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: 'Delete',
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _confirmDelete(context, p.barcodeNo),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _showNotFoundDialog(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Product not found'),
        content: Text('Barcode: $barcode\nWould you like to add a new product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => const ProductFormDialog(),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm delete'),
        content: Text('Delete product with barcode:\n$barcode ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final provider = context.read<ProductProvider>();
              final err = await provider.deleteProduct(barcode);
              if (!context.mounted) return;

              _showMsg(context, err ?? 'Product deleted');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
