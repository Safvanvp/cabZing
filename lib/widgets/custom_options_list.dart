import 'package:flutter/material.dart';
import 'package:vikincode/screens/sale_list.dart';

class DashboardListView extends StatelessWidget {
  DashboardListView({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> items = [
    {
      'icon': Icons.schedule,
      'color': Colors.yellow[100],
      'label': 'Bookings',
      'value': '123',
      'subtext': 'Reserved',
      'onTap': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SaleList()));
      }
    },
    {
      'icon': Icons.person,
      'color': const Color(0xFF64FFDA),
      'label': 'Invoices',
      'value': '10,232.00',
      'subtext': 'Rupees',
      'onTap': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SaleList()));
      }
    },
    {
      'icon': Icons.history,
      'color': Colors.yellow[100],
      'label': 'History',
      'value': '256',
      'subtext': 'Trips',
      'onTap': (BuildContext context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SaleList()));
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => item['onTap'](context),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  // Left capsule icon
                  Container(
                    width: 40,
                    height: 100,
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Icon(
                        item['icon'],
                        color: Colors.teal,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Text area
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['label'],
                          style: TextStyle(
                            color: Colors.teal.shade100,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['value'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtext'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow icon
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
