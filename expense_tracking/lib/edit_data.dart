import 'package:expense_tracking/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDataScreen extends StatefulWidget {
  final Map<String, dynamic> keysValues;
  final VoidCallback? onUpdateSuccess;

  const EditDataScreen({
    required this.keysValues,
    this.onUpdateSuccess,
    super.key,
  });

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = [
      TextEditingController(
        text: widget.keysValues[AppDatabase.columnItem]?.toString() ?? "",
      ),
      TextEditingController(
        text: widget.keysValues[AppDatabase.columnQty]?.toString() ?? "",
      ),
      TextEditingController(
        text: widget.keysValues[AppDatabase.columnPrice]?.toString() ?? "",
      ),
      TextEditingController(
        text: widget.keysValues[AppDatabase.columnDate]?.toString() ?? "",
      ),
      TextEditingController(
        text:
            widget.keysValues[AppDatabase.columnDescription]?.toString() ?? "",
      ),
    ];
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Data",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent, Colors.white],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            "Item Name",
                            _controllers[0],
                            Icons.shopping_bag,
                          ),
                          _buildTextField(
                            "Quantity",
                            _controllers[1],
                            Icons.confirmation_number,
                          ),
                          _buildTextField(
                            "Price",
                            _controllers[2],
                            Icons.currency_rupee,
                            isNumber: true,
                          ),
                          _buildTextField(
                            "Date",
                            _controllers[3],
                            Icons.date_range,
                          ),
                          _buildTextField(
                            "Description",
                            _controllers[4],
                            Icons.description_outlined,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _saveChanges(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.blue.shade300,
                            ),
                            child: const Text(
                              'SAVE CHANGES',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (label == "Description" && (value == null || value.isEmpty)) {
            return null;
          }
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          if (isNumber && double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  // In _saveChanges method:
  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final db = context.read<AppDatabase>(); // Get database from context

      await db.updateRow(
        id: widget.keysValues[AppDatabase.columnId],
        dateValue: _controllers[3].text,
        itemValue: _controllers[0].text,
        qtyValue: _controllers[1].text,
        priceValue: double.parse(_controllers[2].text),
        descriptionValue: _controllers[4].text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      if (widget.onUpdateSuccess != null) {
        widget.onUpdateSuccess!();
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving changes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
