import 'package:flutter/material.dart';
import 'package:app_manager/models/order/order_model.dart';
import 'package:intl/intl.dart';
import 'package:app_manager/repositories/order_repository.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({required this.order});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _selectedStatus;
  bool _isUpdating = false; // Để theo dõi trạng thái cập nhật
  final OrderRepository _repository = OrderRepository();

  @override
  void initState() {
    super.initState();
    _selectedStatus =
        widget.order.status; // Khởi tạo giá trị trạng thái hiện tại
  }

  // Hàm gọi API cập nhật trạng thái
  Future<void> _updateStatus(String orderId, String status) async {
    setState(() {
      _isUpdating = true; // Bắt đầu cập nhật
    });

    try {
      bool success = await _repository.updateOrderStatus(orderId, status);
      if (success) {
        // Nếu cập nhật thành công, cập nhật trạng thái trong UI
        setState(() {
          widget.order.status = status;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order status updated to $status')),
        );
      }
    } catch (error) {
      // Hiển thị lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $error')),
      );
    } finally {
      setState(() {
        _isUpdating = false; // Kết thúc cập nhật
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
        .format(widget.order.totalAmount);

    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Thông tin đơn hàng
          Card(
            elevation: 8,
            margin: EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.order.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue)),
                  Text('Phone: ${widget.order.phone}',
                      style: TextStyle(fontSize: 16)),
                  Text('Address: ${widget.order.address}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

          // Divider for clarity
          Divider(thickness: 2),

          // Dropdown để chọn trạng thái mới
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Status:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black)),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  onChanged: _isUpdating
                      ? null
                      : (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                          });
                          // Gọi API cập nhật trạng thái ngay khi thay đổi
                          _updateStatus(widget.order.id, _selectedStatus);
                        },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: [
                    'PENDING',
                    'CONFIRMED',
                    'SHIPPED',
                    'DELIVERED',
                    'CANCELLED',
                  ].map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status, style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Các thông tin khác về đơn hàng
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Method: ${widget.order.paymentMethod}',
                    style: TextStyle(fontSize: 16)),
                Text('Payment Status: ${widget.order.paymentStatus}',
                    style: TextStyle(fontSize: 16)),
                Text('Total: $formattedAmount',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green)),
                Text('Created At: ${widget.order.createdAt}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // Divider to separate products
          Divider(thickness: 2),

          // Danh sách sản phẩm
          Text('Products:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...widget.order.products.map((product) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(product.product.productName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Qty: ${product.quantity} - ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(product.product.price)}'),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
