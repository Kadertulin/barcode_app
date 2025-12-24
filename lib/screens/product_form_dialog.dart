import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductFormDialog extends StatefulWidget {
  final Product? initial; 

  const ProductFormDialog({super.key, this.initial});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _barcodeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _unitPriceCtrl;
  late final TextEditingController _taxRateCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;

  bool _saving = false;

  bool get isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();

    _barcodeCtrl = TextEditingController(text: widget.initial?.barcodeNo ?? '');
    _nameCtrl = TextEditingController(text: widget.initial?.productName ?? '');
    _categoryCtrl = TextEditingController(text: widget.initial?.category ?? '');
    _unitPriceCtrl = TextEditingController(
        text: widget.initial?.unitPrice.toString() ?? '');
    _taxRateCtrl =
        TextEditingController(text: widget.initial?.taxRate.toString() ?? '');
    _priceCtrl =
        TextEditingController(text: widget.initial?.price.toString() ?? '');
    _stockCtrl = TextEditingController(
        text: widget.initial?.stockInfo?.toString() ?? '');
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _unitPriceCtrl.dispose();
    _taxRateCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(
                  controller: _barcodeCtrl,
                  label: 'BarcodeNo',
                  enabled: !isEdit, 
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Barcode boş olamaz';
                    }
                    return null;
                  },
                ),
                _field(
                  controller: _nameCtrl,
                  label: 'ProductName',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'ProductName boş olamaz';
                    }
                    return null;
                  },
                ),
                _field(
                  controller: _categoryCtrl,
                  label: 'Category',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Category boş olamaz';
                    }
                    return null;
                  },
                ),
                _field(
                  controller: _unitPriceCtrl,
                  label: 'UnitPrice',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final val = double.tryParse((v ?? '').trim());
                    if (val == null) return 'UnitPrice sayı olmalı';
                    if (val < 0) return 'UnitPrice negatif olamaz';
                    return null;
                  },
                ),
                _field(
                  controller: _taxRateCtrl,
                  label: 'TaxRate (%)',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final val = int.tryParse((v ?? '').trim());
                    if (val == null) return 'TaxRate tam sayı olmalı';
                    if (val < 0) return 'TaxRate negatif olamaz';
                    if (val > 100) return 'TaxRate 0-100 arası olmalı';
                    return null;
                  },
                ),

                _field(
                  controller: _priceCtrl,
                  label: 'Price',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final val = double.tryParse((v ?? '').trim());
                    if (val == null) return 'Price sayı olmalı';
                    if (val < 0) return 'Price negatif olamaz';
                    return null;
                  },
                ),
                _field(
                  controller: _stockCtrl,
                  label: 'StockInfo (optional)',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final text = (v ?? '').trim();
                    if (text.isEmpty) return null; 
                    final val = int.tryParse(text);
                    if (val == null) return 'StockInfo tam sayı olmalı';
                    if (val < 0) return 'StockInfo negatif olamaz';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _onSave,
          child: Text(_saving ? 'Saving...' : 'Save'),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final product = Product(
      barcodeNo: _barcodeCtrl.text.trim(),
      productName: _nameCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      unitPrice: double.parse(_unitPriceCtrl.text.trim()),
      taxRate: int.parse(_taxRateCtrl.text.trim()),
      price: double.parse(_priceCtrl.text.trim()),
      stockInfo: _stockCtrl.text.trim().isEmpty
          ? null
          : int.parse(_stockCtrl.text.trim()),
    );

    final provider = context.read<ProductProvider>();

    
    final err = await provider.addProduct(product);

    if (!mounted) return;

    if (err != null) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    Navigator.pop(context); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product saved')),
    );
  }
}
