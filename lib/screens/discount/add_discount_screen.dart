import 'package:app_manager/models/discount/discount_dto.dart';
import 'package:app_manager/providers/discount/discount_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDiscountScreen extends StatefulWidget {
  const AddDiscountScreen({super.key});

  @override
  State<AddDiscountScreen> createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();

  final TextEditingController _percentageController = TextEditingController();

  final TextEditingController _usageLimitController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  void _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;

        _dateController.text =
            _selectedDate!.toLocal().toIso8601String().split('T').first;
      });
    }
  }

  void _saveDiscount() {
    if (_formKey.currentState!.validate()) {
      final discount = DiscountDto(
        discountCode: _codeController.text,
        discountPercentage: int.parse(_percentageController.text),
        expiredAt: _selectedDate,
        usageLimit: _usageLimitController.text.isEmpty
            ? null
            : int.parse(_usageLimitController.text),
      );
      context.read<DiscountCubit>().addDiscount(discount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Discount'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Discount Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a discount code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _percentageController,
                decoration: InputDecoration(
                  labelText: 'Discount Percentage',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a discount percentage';
                  }
                  final percentage = int.tryParse(value);
                  if (percentage == null ||
                      percentage <= 0 ||
                      percentage > 100) {
                    return 'Percentage must be between 1 and 100';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Expired At',
                      hintText: _selectedDate == null
                          ? 'Select a date'
                          : _selectedDate!
                              .toLocal()
                              .toIso8601String()
                              .split('T')
                              .first,
                    ),
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Please select an expiration date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usageLimitController,
                decoration: InputDecoration(
                  labelText: 'Usage Limit (optional)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final usageLimit = int.tryParse(value);
                    if (usageLimit == null || usageLimit <= 0) {
                      return 'Usage limit must be a positive number';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              BlocConsumer<DiscountCubit, DiscountState>(
                  listener: (context, state) {
                if (state is DiscountAddFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                } else if (state is DiscountAddSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thêm mã giảm giá thành công')),
                  );
                  Navigator.of(context).pop();
                }
              }, builder: (context, state) {
                if (state is DiscountAddLoading) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () => _saveDiscount(),
                  child: Text('Thêm sản phẩm'),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
