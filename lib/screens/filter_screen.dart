import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String dateRange = 'This Month';
  DateTime? startDate;
  DateTime? endDate;
  String status = 'Pending';
  String? selectedCustomer;
  final List<String> dateRanges = [
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'Last Month',
    'Custom',
  ];
  final List<String> statuses = ['Pending', 'Invoiced', 'Cancelled'];
  final List<String> customers = [
    'savad farooque',
    'john doe',
    'jane smith',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = now;
    endDate = now;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate! : endDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xFF18181B),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Filter',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          Icon(Icons.remove_red_eye_outlined, color: Colors.blue),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Filter',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Dropdown
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF18181B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF18181B),
                    value: dateRange,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: dateRanges
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        dateRange = val!;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Date Pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DateButton(
                  date: startDate!,
                  onTap: () => _pickDate(isStart: true),
                ),
                const SizedBox(width: 16),
                _DateButton(
                  date: endDate!,
                  onTap: () => _pickDate(isStart: false),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              color: const Color.fromARGB(255, 100, 100, 100),
              thickness: 1,
            ),
            const SizedBox(height: 10),

            // Status Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: statuses.map((s) {
                final selected = status == s;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (_) => setState(() => status = s),
                    selectedColor: Colors.blue,
                    backgroundColor: const Color(0xFF23232A),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            // Customer Dropdown
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 100, 100, 100),
                  width: 1,
                ),
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCustomer,
                  hint: const Text('Customer',
                      style: TextStyle(color: Colors.white54)),
                  dropdownColor: const Color(0xFF18181B),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
                  items: customers
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCustomer = val;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Selected Customer Chip
            if (selectedCustomer != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23232A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(selectedCustomer!,
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => selectedCustomer = null),
                        child: const Icon(Icons.close, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  const _DateButton({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF23232A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Text(
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
