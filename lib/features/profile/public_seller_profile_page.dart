import 'package:flutter/material.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';

class PublicSellerProfilePage extends StatelessWidget {
  const PublicSellerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AppSurface(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Local Student Seller'),
              subtitle: Text('Joined: Jan 2025 • Campus Area'),
            ),
          ),
          SizedBox(height: 8),
          AppSurface(child: ListTile(leading: Icon(Icons.star_outline), title: Text('Rating'), trailing: Text('4.5'), contentPadding: EdgeInsets.zero)),
          SizedBox(height: 8),
          AppSurface(child: ListTile(leading: Icon(Icons.menu_book_outlined), title: Text('Active listings'), trailing: Text('12'), contentPadding: EdgeInsets.zero)),
          SizedBox(height: 8),
          AppSurface(child: ListTile(leading: Icon(Icons.shopping_bag_outlined), title: Text('Sold books'), trailing: Text('39'), contentPadding: EdgeInsets.zero)),
        ],
      ),
    );
  }
}
