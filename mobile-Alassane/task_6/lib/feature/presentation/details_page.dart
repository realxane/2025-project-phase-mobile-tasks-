import 'package:flutter/material.dart';
import 'package:task_6/core/routes/app_routes.dart';
import 'package:task_6/feature/domain/product.dart';
import 'package:task_6/feature/data/repositories/in_memory_product_repository.dart';
import 'package:task_6/feature/domain/usecases/delete_product_usecase.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  const DetailsPage({super.key, required this.product});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final List<int> sizes = [39, 40, 41, 42, 43, 44, 45, 46];
  int selectedSize = 41;

  late final InMemoryProductRepository _repository;
  late final DeleteProductUseCase _deleteProductUseCase;

  @override
  void initState() {
    super.initState();
    _repository = InMemoryProductRepository();
    _deleteProductUseCase = DeleteProductUseCase(_repository);
  }

  void _onDelete() {
    try {
      _deleteProductUseCase(DeleteProductParams(widget.product.id));
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error while deleting item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = widget.product;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Image part + back button
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 30 / 20,
                    child: Container(
                      color: const Color(0xFFEDEEF2),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Image.network(
                          p.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 12,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Navigator.of(context).maybePop(false),
                      ),
                    ),
                  ),
                ],
              ),

              // Content part
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + price + rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.category,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.55),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                p.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFC107),
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${p.rating.toStringAsFixed(1)})',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.55),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${p.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Size
                    const Text(
                      'Size:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: sizes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final size = sizes[index];
                          final bool isSelected = size == selectedSize;
                          return InkWell(
                            onTap: () => setState(() => selectedSize = size),
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 56,
                              decoration: BoxDecoration(
                                color: isSelected ? cs.primary : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? cs.primary
                                      : const Color(0xFFE3E5EA),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: cs.primary.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 6),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '\$size',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Description
                    Text(
                      p.description,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                              side: BorderSide(color: Colors.red.shade400),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _onDelete,
                            child: const Text(
                              'DELETE',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              final updated = await Navigator.pushNamed(
                                context,
                                AppRoutes.addUpdate,
                                arguments: widget.product,
                              );

                              if (!mounted) return;

                              // Si AddUpdatePage renvoie true, on remonte l’info
                              if (updated == true) {
                                Navigator.of(context).pop(true);
                              }
                            },
                            child: const Text(
                              'UPDATE',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}