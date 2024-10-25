import 'package:app_manager/screens/order/order_screen.dart';
import 'package:app_manager/screens/product/product_screen.dart';
import 'package:app_manager/screens/user/user_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    //NavigationRail
    switch (selectedIndex) {
      case 0:
        page = Center(
          child: Text('Welcome to Home Screen!'),
        );
        break;
      case 1:
        page = ProductScreen();
        break;
      case 2:
        page = UserScreen();
        break;
      case 3:
        page = OrderScreen();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600, // ← Here.
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.shopping_cart),
                    label: Text('Sản phẩm'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Người dùng'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.shopping_bag),
                    label: Text('Đơn hàng'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
