// home_screen.dart
import 'package:app_manager/screens/dashboard/dash_board_screen.dart';
import 'package:app_manager/screens/discount/discount_screen.dart';
import 'package:app_manager/screens/order/order_screen.dart';
import 'package:app_manager/screens/product/product_screen.dart';
import 'package:app_manager/screens/user/user_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chủ'),
        centerTitle: true,
        backgroundColor: Colors.green[50],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // Hai cột
          children: [
            _buildGridTile(context, 'Sản phẩm', ProductScreen()),
            _buildGridTile(context, 'Người dùng', UserScreen()),
            _buildGridTile(context, 'Đơn hàng', OrderScreen()),
            _buildGridTile(context, 'Dashboard', DashBoardScreen()),
            _buildGridTile(context, 'Mã giảm giá', DiscountScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        child: Card(
          child: SizedBox(
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
