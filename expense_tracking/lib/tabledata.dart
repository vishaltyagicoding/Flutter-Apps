import 'package:expense_tracking/database/app_database.dart';
import 'package:expense_tracking/edit_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompleteTableScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allData;

  const CompleteTableScreen({super.key, required this.allData});

  @override
  State<CompleteTableScreen> createState() => _CompleteTableScreenState();
}

class _CompleteTableScreenState extends State<CompleteTableScreen> {
  late List<Map<String, dynamic>> _allData;
  List<Map<String, dynamic>> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use widget.allData as initial data
    _allData = List.from(widget.allData);
    _filteredData = List.from(_allData);
    _searchController.addListener(_filterData);
  }

  @override
  void didUpdateWidget(covariant CompleteTableScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update data when parent widget provides new data
    if (widget.allData != oldWidget.allData) {
      _refreshLocalData();
    }
  }

  void _refreshLocalData() {
    setState(() {
      _allData = List.from(widget.allData);
      _filteredData = List.from(_allData);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredData = List.from(_allData);
      });
    } else {
      setState(() {
        _filteredData = _allData.where((item) {
          return item[AppDatabase.columnItem].toString().toLowerCase().contains(
                query,
              ) ||
              item[AppDatabase.columnQty].toString().toLowerCase().contains(
                query,
              ) ||
              item[AppDatabase.columnPrice].toString().toLowerCase().contains(
                query,
              ) ||
              item[AppDatabase.columnDate].toString().contains(query) ||
              (item[AppDatabase.columnDescription]
                      ?.toString()
                      .toLowerCase()
                      .contains(query) ??
                  false);
        }).toList();
      });
    }
  }

  Future<void> _refreshDataFromDatabase() async {
    final db = context.read<AppDatabase>();
    final updatedData = await db.getAllData();

    setState(() {
      _allData = List.from(updatedData);
      _filteredData = List.from(_allData);
      // Reset search if active
      if (_searchController.text.isNotEmpty) {
        _filterData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Records'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDataFromDatabase,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by item, description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterData();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _filteredData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No expenses found'
                              : 'No matching expenses found',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${index + 1}. ${item[AppDatabase.columnItem]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '₹${item[AppDatabase.columnPrice].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.blue,
                                    ),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditDataScreen(
                                              keysValues: item,
                                              onUpdateSuccess: () async {
                                                // Refresh data from database after edit
                                                await _refreshDataFromDatabase();
                                              },
                                            ),
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _showDeleteDialog(
                                          context,
                                          item[AppDatabase.columnId],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      'Qty: ${item[AppDatabase.columnQty]}',
                                    ),
                                    backgroundColor: Colors.blue[50],
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(item[AppDatabase.columnDate]),
                                    backgroundColor: Colors.grey[100],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (item[AppDatabase.columnDescription] != null &&
                                  item[AppDatabase.columnDescription]
                                      .toString()
                                      .isNotEmpty)
                                Text(
                                  item[AppDatabase.columnDescription],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    final db = context.read<AppDatabase>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await db.deleteRow(id);
              // Refresh data after deletion
              await _refreshDataFromDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Expense deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
