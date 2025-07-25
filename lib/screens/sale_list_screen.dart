import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SaleListScreen extends StatefulWidget {
  const SaleListScreen({Key? key}) : super(key: key);

  @override
  State<SaleListScreen> createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  final _storage = const FlutterSecureStorage();
  List<dynamic> _sales = [];
  List<dynamic> _filteredSales = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _pageNumber = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSales();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSales = _sales.where((item) {
        final name = (item['CustomerName'] ?? '').toString().toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<void> _fetchSales() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final token = await _storage.read(key: 'token');
      final userID = await _storage.read(key: 'userID');
      final url = Uri.parse(
          'https://www.api.viknbooks.com/api/v10/sales/sale-list-page/');
      final payload = {
        "BranchID": 1,
        "CompanyID": "1901b825-fe6f-418d-b5f0-7223d0040d08",
        "CreatedUserID": userID ?? 1,
        "PriceRounding": 2,
        "page_no": _pageNumber,
        "items_per_page": 10,
        "type": "Sales",
        "WarehouseID": 1
      };
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API response: $data');
        final results = data['results'] ?? data['data'] ?? [];
        setState(() {
          _sales = results is List ? results : [];
          _filteredSales = _sales;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch sales: \n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Sale List'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSales,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Search by Customer Name',
                labelStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Color(0xFF18181B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              ),
            if (!_isLoading && _filteredSales.isEmpty && _errorMessage == null)
              const Expanded(
                  child: Center(
                      child: Text('No sales found.',
                          style: TextStyle(color: Colors.white54)))),
            if (!_isLoading && _filteredSales.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = _filteredSales[index];
                    return Card(
                      color: const Color(0xFF18181B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(
                            sale['CustomerName']?.toString() ?? 'No Name',
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                            'Invoice: \\${sale['InvoiceNo'] ?? 'N/A'}',
                            style: const TextStyle(color: Colors.white70)),
                        trailing: Text('Total: \\${sale['GrandTotal'] ?? '0'}',
                            style: const TextStyle(color: Colors.blue)),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
