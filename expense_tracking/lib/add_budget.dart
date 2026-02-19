import 'package:expense_tracking/database/app_database.dart';
import 'package:expense_tracking/setting.dart';
import 'package:expense_tracking/tabledata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({super.key});

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  final TextEditingController item = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController qty = TextEditingController();
  final TextEditingController description = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode _itemFocusNode = FocusNode();
  String selectedDate = DateTime.now().toString().split(' ')[0];

  @override
  void initState() {
    super.initState();
    // Initialize database data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppDatabase>().initialize();
    });
  }

  @override
  void dispose() {
    item.dispose();
    amount.dispose();
    qty.dispose();
    description.dispose();
    _itemFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Consumer<AppDatabase>(
        builder: (context, db, child) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    'Expense Tracker',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // In the drawer's Data ListTile onTap:
                ListTile(
                  leading: const Icon(Icons.data_usage),
                  title: const Text('Data'),
                  onTap: () {
                    Navigator.pop(context);
                    final db = context.read<AppDatabase>();
                    if (db.allData.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No Data available')),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompleteTableScreen(allData: db.allData),
                        ),
                      );
                    }
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text('Setting'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Setting()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: Text('Total: ₹${db.totalAmount.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(13),
                Theme.of(context).colorScheme.primary.withAlpha(5),
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 1),
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildTextField("Item Name", item, Icons.shopping_bag),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Qty",
                          qty,
                          Icons.numbers,
                          inputFormatter: LengthLimitingTextInputFormatter(13),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          "Price",
                          amount,
                          Icons.currency_rupee,
                          keyboardType: TextInputType.number,
                          inputFormatter: LengthLimitingTextInputFormatter(13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    "Description",
                    description,
                    Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTotalSection(),
                  const SizedBox(height: 16),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_chart,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Add New Expense',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Fill in the details below to track your expense',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField(
    String labelText,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.multiline,
    LengthLimitingTextInputFormatter? inputFormatter,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: controller == item ? _itemFocusNode : null,
        keyboardType: keyboardType,
        inputFormatters: [if (inputFormatter != null) inputFormatter],
        style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          hintText: "Enter $labelText",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Container(
            margin: const EdgeInsets.all(7),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        validator: (value) {
          if (controller == description && (value == null || value.isEmpty)) {
            return null;
          }
          if ((value == null || value.trim().isEmpty)) {
            if (controller == qty || controller == amount) {
              return 'Please enter \n$labelText';
            } else {
              return 'Please enter $labelText';
            }
          }
          if (keyboardType == TextInputType.number &&
              double.tryParse(value) == null) {
            return 'Not valid \nnumber';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTotalSection() {
    return Consumer<AppDatabase>(
      builder: (context, db, child) {
        return Container(
          padding: const EdgeInsets.all(14),
          color: Colors.blue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  final newDate = DateTime.parse(
                    selectedDate,
                  ).subtract(const Duration(days: 1));
                  setState(() {
                    selectedDate = newDate.toString().split(' ')[0];
                  });
                },
              ),
              Column(
                children: [
                  Text(
                    selectedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${db.allData.length} items',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  final newDate = DateTime.parse(
                    selectedDate,
                  ).add(const Duration(days: 1));
                  setState(() {
                    selectedDate = newDate.toString().split(' ')[0];
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          try {
            FocusScope.of(context).unfocus();

            final db = context.read<AppDatabase>();

            await db.insertRow(
              dateValue: selectedDate,
              itemValue: item.text.trim(),
              qtyValue: qty.text.trim(),
              priceValue: double.tryParse(amount.text.trim()) ?? 0.0,
              descriptionValue: description.text.trim(),
            );

            _showSuccessDialog();

            item.clear();
            amount.clear();
            qty.clear();
            description.clear();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(_itemFocusNode);
            });
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to save expense: $e'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.primary.withAlpha(77),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 20),
          SizedBox(width: 10),
          Text(
            'SAVE EXPENSE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Icon(
          Icons.check_circle,
          size: 60,
          color: Theme.of(context).colorScheme.primary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Success!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Expense has been saved successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }
}
