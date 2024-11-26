import 'package:flutter/material.dart';
import 'package:app_manager/models/order/order_model.dart';
import 'package:app_manager/repositories/order_repository.dart';
import 'order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderRepository _repository = OrderRepository();
  List<Order> _orders = [];
  int _page = 1;
  int _totalPages = 1; // Giới hạn tổng số trang
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (_page > _totalPages || _page < 1) return; // Kiểm tra giới hạn trang

    try {
      final result = await _repository.fetchOrders(_page, _selectedStatus);
      setState(() {
        _orders = result['orders']; // Thay vì thêm, chúng ta gán dữ liệu mới
        _totalPages = result['totalPage']; // Cập nhật tổng số trang
      });
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  void _onPageChange(int newPage) {
    setState(() {
      _page = newPage; // Thay đổi trang hiện tại
    });
    _fetchOrders(); // Gọi hàm để tải dữ liệu của trang mới
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: Column(
        children: [
          // Dropdown để lọc trạng thái đơn hàng
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedStatus ?? 'CONFIRMED',
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                  _page = 1; // Quay về trang đầu tiên khi thay đổi trạng thái
                  _fetchOrders();
                });
              },
              items: [
                'ALL',
                'PENDING',
                'CONFIRMED',
                'SHIPPED',
                'DELIVERED',
                'CANCELLED',
              ].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
            ),
          ),
          // Danh sách các đơn hàng
          Expanded(
            child: ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                // Định dạng totalAmount thành tiền tệ Việt Nam
                String formattedAmount =
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(order.totalAmount);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text('Order ID: ${order.id}'),
                    subtitle: Text('Total Amount: $formattedAmount'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Phân trang
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Nút Previous
                ElevatedButton(
                  onPressed: _page > 1 ? () => _onPageChange(_page - 1) : null,
                  child: const Text('Previous'),
                ),
                Text('Page $_page of $_totalPages'),
                // Nút Next
                ElevatedButton(
                  onPressed: _page < _totalPages
                      ? () => _onPageChange(_page + 1)
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
