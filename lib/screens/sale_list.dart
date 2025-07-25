import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vikincode/screens/filter_screen.dart';

class SaleList extends StatefulWidget {
  const SaleList({super.key});

  @override
  State<SaleList> createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {
  List<dynamic> invoices = [];
  List<dynamic> filteredInvoices = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSales();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredInvoices = invoices
          .where((item) =>
              item['CustomerName'].toLowerCase().contains(query) ||
              item['InvoiceNo'].toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> fetchSales() async {
    const url = 'https://www.api.viknbooks.com/api/v10/sales/sale-list-page/';

    // Securely read token & userID
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final userId = await storage.read(key: 'userID');

    if (token == null || userId == null) {
      print('❌ Token or user ID not found');
      setState(() => isLoading = false);
      return;
    }

    final payload = {
      "BranchID": 1,
      "CompanyID": "1901b825-fe6f-418d-b5f0-7223d0040d08",
      "CreatedUserID": int.parse(userId),
      "PriceRounding": 2,
      "page_no": 1,
      "items_per_page": 10,
      "type": "Sales",
      "WarehouseID": 1
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'] ?? [];

        setState(() {
          invoices = data;
          filteredInvoices = data;
          isLoading = false;
        });
      } else {
        print('❌ Failed to load data: ${response.body}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('❌ Error fetching sales: $e');
      setState(() => isLoading = false);
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.red;
      case 'invoiced':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Invoices',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Divider(color: Color.fromARGB(255, 100, 100, 100)),
                const SizedBox(height: 10),

                // 🔍 Search + Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // 🔍 Search
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 42, 39, 50),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 100, 100, 100)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(Icons.search,
                                    size: 24,
                                    color: Color.fromARGB(255, 165, 165, 165)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // 🎛 Filter
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FilterScreen()),
                            );
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 43, 52, 72),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_list_rounded,
                                      size: 26, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Filter',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Color.fromARGB(255, 100, 100, 100)),
                const SizedBox(height: 10),

                // 📋 Invoice List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredInvoices.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      final item = filteredInvoices[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['InvoiceNo'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['CustomerName'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                // Right
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item['Status'] ?? '',
                                      style: TextStyle(
                                        color: getStatusColor(
                                            item['Status'] ?? ''),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Text(
                                          'SAR. ',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                        Text(
                                          item['NetAmount']?.toString() ?? '0',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 100),
                              child: Divider(
                                color: const Color.fromARGB(255, 97, 110, 185),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
