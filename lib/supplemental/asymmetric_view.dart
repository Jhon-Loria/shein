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

  @override
  Widget build(BuildContext context) {
    // TODO: Add a grid view (102)
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      children: _buildGridCards(context),
    );
  }

  List<Card> _buildGridCards(BuildContext context) {
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        elevation: 0.0,
        child: Column(
          // TODO: Center items on the card (103)
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    _getProductImageUrl(product.id),
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: _getProductColor(product.id),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Icon(
                            _getProductIcon(product.id),
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  // TODO: Align labels to the bottom and center (103)
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // TODO: Change innermost Column (103)
                  children: <Widget>[
                    // TODO: Handle overflowing labels (103)
                    Text(
                      product.name,
                      style: theme.textTheme.labelLarge,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
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
      // ACCESSORIES (0-8)
      'https://images.unsplash.com/photo-1622560481156-01fc7e1693e6?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 0: Vagabond sack
      'https://plus.unsplash.com/premium_photo-1755553445914-3825d002aa71?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 1: Stella sunglasses
      'https://images.unsplash.com/photo-1750175546523-f771dcde8d5f?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%', // 2: Whitney belt
      'https://images.unsplash.com/photo-1655731739305-67958f705170?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 3: Garden strand
      'https://images.unsplash.com/photo-1496957961599-e35b69ef5d7c?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 4: Strut earrings
      'https://images.unsplash.com/photo-1733744236936-bcb5abc19f63?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 5: Varsity socks
      'https://images.unsplash.com/photo-1593671186131-d58817e7dee0?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 6: Weave keyring
      'https://images.unsplash.com/photo-1678099283805-bf9b60237289?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 7: Gatsby hat
      'https://images.unsplash.com/photo-1448582649076-3981753123b5?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 8: Shrug bag
      
      // HOME ITEMS (9-18)
      'https://images.unsplash.com/photo-1646705193300-aa2815a15bcd?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 9: Gilt desk trio
      'https://images.unsplash.com/photo-1613335363385-561d216954cc?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 10: Copper wire rack
      'https://images.unsplash.com/photo-1715370038406-f471edf86328?q=80&w=1233&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 11: Soothe ceramic set
      'https://images.unsplash.com/photo-1584428885051-d80a38d86b39?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 12: Hurrahs tea set
      'https://images.unsplash.com/photo-1755638110931-3da1d1174c14?q=80&w=1112&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 13: Blue stone mug
      'https://images.unsplash.com/photo-1646021798748-4049ca4191c0?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 14: Rainwater tray
      'https://plus.unsplash.com/premium_photo-1673481600840-a261d546b2bf?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 15: Chambray napkins
      'https://plus.unsplash.com/premium_photo-1668416114981-1d6cd2acbc7d?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 16: Succulent planters
      'https://images.unsplash.com/photo-1643913591623-4335627a1677?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 17: Quartet table
      'https://images.unsplash.com/photo-1708915965975-2a950db0e215?q=80&w=1112&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 18: Kitchen quattro

      // CLOTHING (19-37)
      'https://plus.unsplash.com/premium_photo-1733701621287-f1023730af18?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 19: Clay sweater
      'https://images.unsplash.com/photo-1555272899-13b1d044bc7e?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 20: Sea tunic
      'https://images.unsplash.com/photo-1591130901966-1b6770de5120?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 21: Plaster tunic
      'https://images.unsplash.com/photo-1758180501142-fd64566c3531?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 22: White pinstripe shirt
      'https://images.unsplash.com/photo-1713881630214-82c44407cf25?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 23: Chambray shirt
      'https://plus.unsplash.com/premium_photo-1758698145702-7f08b2dae2b3?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 24: Seabreeze sweater
      'https://plus.unsplash.com/premium_photo-1664298280363-51c8881ce9ba?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 25: Gentry jacket
      'https://plus.unsplash.com/premium_photo-1661687201493-12dc7e962519?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 26: Navy trousers
      'https://plus.unsplash.com/premium_photo-1724075323608-f02348de3ed7?q=80&w=1138&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 27: Walter henley (white)
      'https://plus.unsplash.com/premium_photo-1750153889694-a80bbcb14e86?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 28: Surf and perf shirt
      'https://images.unsplash.com/photo-1737061556974-4d0ac84f46b2?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 29: Ginger scarf
      'https://plus.unsplash.com/premium_photo-1691622500309-6976109c80b9?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 30: Ramona crossover
      'https://images.unsplash.com/photo-1623658580851-3b25bf83b4ea?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 31: Chambray shirt
      'https://plus.unsplash.com/premium_photo-1739548335715-cd815b9c5e6f?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 32: Classic white collar
      'https://plus.unsplash.com/premium_photo-1682633540291-6229fc6845ec?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 33: Cerise scallop tee
      'https://plus.unsplash.com/premium_photo-1741708875396-afc14c43b4ff?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 34: Shoulder rolls tee
      'https://images.unsplash.com/photo-1737094540214-261561588b89?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 35: Grey slouch tank
      'https://plus.unsplash.com/premium_photo-1661380487022-4aac8ec31625?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 36: Sunshirt dress
      'https://plus.unsplash.com/premium_photo-1664910323372-3445d1ff78cc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // 37: Fine lines tee
    ];
    return imageUrls[id];
  }
}

