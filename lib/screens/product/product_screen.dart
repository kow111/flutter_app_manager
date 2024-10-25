import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: const Center(
        child: Text('Welcome to Product Screen!'),
      ),
    );
  }
}
