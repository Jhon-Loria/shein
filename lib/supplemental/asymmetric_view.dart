// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/product.dart';

class AsymmetricView extends StatelessWidget {
  const AsymmetricView({Key? key, required this.products}) : super(key: key);

  final List<Product> products;

  List<Container> _buildColumns(BuildContext context) {
    if (products.isEmpty) {
      return const <Container>[];
    }

    // This will return a list of columns. It will oscillate between the two
    // kinds of columns. Even cases of the index (0, 2, 4, etc) will be
    // TwoProductCardColumn and the odd cases (1, 3, 5, etc) will be
    // OneProductCardColumn.
    //
    // Each pair of columns will advance us 3 products forward (2 + 1). That's
    // some kinda awkward math so we use _evenCasesIndex and _oddCasesIndex as
    // helpers for creating the index of the product list that will correspond
    // to the index of the list of columns.
    return List.generate(_listItemCount(products.length), (int index) {
      double width = .59 * MediaQuery.of(context).size.width;
      Widget column;
      if (index % 2 == 0) {
        // Even cases
        int bottom = _evenCasesIndex(index);
        column = TwoProductCardColumn(
          bottom: products[bottom],
          top: products.length - 1 >= bottom + 1
              ? products[bottom + 1]
              : null,
        );
        width += .21 * MediaQuery.of(context).size.width;
      } else {
        // Odd cases
        int bottom = _oddCasesIndex(index);
        column = OneProductCardColumn(
          product: products[bottom],
        );
      }
      return Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: column,
        ),
      );
    }).toList();
  }

  int _evenCasesIndex(int index) {
    // The operator ~/ is a cool one. It's the truncating division operator. It
    // divides the number and cuts off the decimal. This is like dividing and
    // then casting the result to int. Also, it's way faster.
    return index ~/ 2 * 3;
  }

  int _oddCasesIndex(int index) {
    assert(index > 0);
    return (index / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    if (totalItems % 3 == 0) {
      return totalItems ~/ 3 * 2;
    } else {
      return (totalItems / 3).ceil() * 2 - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(0.0, 34.0, 16.0, 44.0),
      children: _buildColumns(context),
    );
  }
}

class OneProductCardColumn extends StatelessWidget {
  const OneProductCardColumn({Key? key, this.product}) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ProductCard(
            product: product,
            imageAspectRatio: 3.0 / 4.0,
          ),
          const SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }
}

class TwoProductCardColumn extends StatelessWidget {
  const TwoProductCardColumn({
    Key? key,
    this.bottom,
    this.top,
  }) : super(key: key);

  final Product? bottom, top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ProductCard(
            product: top,
            imageAspectRatio: 3.0 / 4.0,
          ),
          const SizedBox(height: 16.0),
          ProductCard(
            product: bottom,
            imageAspectRatio: 3.0 / 4.0,
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.imageAspectRatio,
    this.product,
  }) : super(key: key);

  final double? imageAspectRatio;
  final Product? product;

  static const double kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );
    final ThemeData theme = Theme.of(context);

    final imageWidget = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          _getProductImageUrl(product?.id ?? 0),
          fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: _getProductColor(product?.id ?? 0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: Icon(
                _getProductIcon(product?.id ?? 0),
                size: 60,
                color: Colors.white,
              ),
            ),
          );
        },
        ),
      ),
    );

    return Card(
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: imageAspectRatio ?? 33 / 49,
            child: imageWidget,
          ),
          Container(
            height: kTextBoxHeight,
            width: 121.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  product == null ? '' : product!.name,
                  style: theme.textTheme.labelLarge,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4.0),
                Text(
                  product == null ? '' : formatter.format(product!.price),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getProductColor(int id) {
    final colors = [
      Colors.blue[400]!,      // Vagabond sack
      Colors.orange[400]!,    // Stella sunglasses  
      Colors.brown[400]!,     // Whitney belt
      Colors.green[400]!,     // Garden strand
      Colors.purple[400]!,    // Strut earrings
      Colors.red[400]!,       // Varsity socks
      Colors.teal[400]!,      // Weave keyring
      Colors.indigo[400]!,    // Gatsby hat
      Colors.pink[400]!,      // Shrug bag
      Colors.amber[400]!,     // Gilt desk trio
    ];
    return colors[id % colors.length];
  }

  IconData _getProductIcon(int id) {
    final icons = [
      Icons.backpack,         // Vagabond sack
      Icons.visibility,       // Stella sunglasses
      Icons.circle,           // Whitney belt  
      Icons.nature,           // Garden strand
      Icons.earbuds,          // Strut earrings
      Icons.sports,           // Varsity socks
      Icons.key,              // Weave keyring
      Icons.face,             // Gatsby hat
      Icons.shopping_bag,     // Shrug bag
      Icons.desk,             // Gilt desk trio
    ];
    return icons[id % icons.length];
  }

  String _getProductImageUrl(int id) {
    final imageUrls = [
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop&bg=f5f5f5', // Backpack - Vagabond sack
      'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&h=300&fit=crop&bg=f5f5f5', // Sunglasses - Stella sunglasses
      'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=300&h=300&fit=crop&bg=f5f5f5', // Belt - Whitney belt
      'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=300&h=300&fit=crop&bg=f5f5f5', // Jewelry - Garden strand
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop&bg=f5f5f5', // Earbuds - Strut earrings
      'https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?w=300&h=300&fit=crop&bg=f5f5f5', // Socks - Varsity socks
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop&bg=f5f5f5', // Accessories - Weave keyring
      'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=300&h=300&fit=crop&bg=f5f5f5', // Hat - Gatsby hat
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300&h=300&fit=crop&bg=f5f5f5', // Handbag - Shrug bag
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=300&fit=crop&bg=f5f5f5', // Desk items - Gilt desk trio
    ];
    return imageUrls[id % imageUrls.length];
  }
}