import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_6/feature/domain/product.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product; 

  const AddUpdatePage({super.key, this.product});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _name = TextEditingController();
  final _category = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _name.text = p.title;
      _category.text = p.category;
      _price.text = p.price.toStringAsFixed(0);
      _description.text = p.description;
    }
  }

  final _picker = ImagePicker();
  XFile? _picked;

  Color get _fieldFill => const Color(0xFFF3F4F6);
  BorderRadius get _radius12 => BorderRadius.circular(12);

  Future<void> _pickImage() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => _picked = file);
    } catch (_) {
    }
  }

  InputDecoration _decoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: _radius12,
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffix,
      suffixIconConstraints:
          const BoxConstraints(minWidth: 0, minHeight: 0, maxHeight: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.blue,),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.product == null ? 'Add Product' : 'Edit Product',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const SizedBox(width: 26),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _fieldFill,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _picked == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined,
                                      size: 40, color: Colors.black.withOpacity(0.6)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'upload image',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(_picked!.path),
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(Icons.edit,
                                              size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // name
                    Text('name',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _name,
                      decoration: _decoration(''),
                    ),
                    const SizedBox(height: 14),

                    // category
                    Text('category',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _category,
                      decoration: _decoration(''),
                    ),
                    const SizedBox(height: 14),

                    // price
                    Text('price',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _price,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: _decoration(
                        '',
                        suffix: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EBEF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // description
                    Text('description',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _description,
                      maxLines: 5,
                      decoration: _decoration(''),
                    ),
                    const SizedBox(height: 18),

                    // ADD button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, letterSpacing: 0.5),
                        ),
                        onPressed: () {
                          final title = _name.text.trim();
                          final category = _category.text.trim();
                          final description = _description.text.trim();
                          final price = double.tryParse(_price.text.trim()) ?? 0;

                          if (title.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Title and description are required')),
                            );
                            return;
                          }

                          final old = widget.product;

                          final product = Product(
                            title: title,
                            category: category.isEmpty ? (old?.category ?? 'Uncategorized') : category,
                            price: price,
                            rating: old?.rating ?? 0,
                            imageUrl: old?.imageUrl ??
                                'https://www.oliversweeney.com/cdn/shop/files/Eastington_Cognac_1_sq1_9b3a983e-f624-47a1-ab17-bb58e32ebd40_630x806.progressive.jpg?v=1691063210',
                            description: description,
                          );

                          Navigator.of(context).pop(product); // ⬅️ renvoie le product
                        },
                        child: Text(widget.product == null ? 'ADD' : 'SAVE'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // DELETE button (outline rouge)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF3B30)),
                          foregroundColor: const Color(0xFFFF3B30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, letterSpacing: 0.5),
                        ),
                        onPressed: () {
                          // TODO: 
                        },
                        child: const Text('DELETE'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _price.dispose();
    _description.dispose();
    super.dispose();
  }
}