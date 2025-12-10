import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:task_6/core/routes/app_routes.dart';
import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/product.dart';
import 'package:task_6/feature/domain/product_repository.dart';
import 'package:task_6/feature/data/repositories/in_memory_product_repository.dart';
import 'package:task_6/feature/domain/usecases/view_all_products_usecase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProductRepository _repository;
  late final ViewAllProductsUseCase _viewAllProductsUseCase;

  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _repository = InMemoryProductRepository(); // même singleton que partout
    _viewAllProductsUseCase = ViewAllProductsUseCase(_repository);

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await _viewAllProductsUseCase(const NoParams());

      if (!mounted) return;
      setState(() {
        _products = products;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erreur lors du chargement des produits';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.addUpdate,
            arguments: null,
          );

          if (result == true || result is Product) {
            _loadProducts();
          }
        },
        backgroundColor: cs.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              _HeaderBar(
                name: 'Alassane',
                date: _formatToday(),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Available Products',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  _IconSquare(
                    icon: Icons.search_rounded,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (_isLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else if (_error != null) ...[
                Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ] else if (_products.isEmpty) ...[
                const Center(
                  child: Text('Aucun produit disponible pour le moment.'),
                ),
              ] else ...[
                ListView.separated(
                  itemCount: _products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final p = _products[index];
                    return _ProductCard(
                      product: p,
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.details,
                          arguments: p,
                        );

                        if (result == true || result is Product) {
                          _loadProducts();
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _formatToday() {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}

class _HeaderBar extends StatelessWidget {
  final String name;
  final String date;
  const _HeaderBar({required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFE9EBEF),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                  children: [
                    const TextSpan(text: 'Hello, '),
                    TextSpan(text: name, style: TextStyle(color: cs.primary)),
                  ],
                ),
              ),
            ],
          ),
        ),

        _NotifSquare(
          onTap: () {},
          hasUnread: true,
        ),
      ],
    );
  }
}

class _NotifSquare extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasUnread;
  const _NotifSquare({required this.onTap, this.hasUnread = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Center(
                child: Icon(Iconsax.notification,
                    color: Colors.black87, size: 22),
              ),
              if (hasUnread)
                Positioned(
                  right: 11,
                  top: 9,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconSquare({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.black87.withOpacity(0.55), size: 22),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: const Color(0xFFEDEEF2),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.55),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 18, color: Color(0xFFFFC107)),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.rating.toStringAsFixed(1)})',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.55),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}