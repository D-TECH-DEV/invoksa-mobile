import 'package:flutter/material.dart';

class InvoiceCreatePage extends StatefulWidget {
  const InvoiceCreatePage({Key? key}) : super(key: key);

  @override
  State<InvoiceCreatePage> createState() => _InvoiceCreatePageState();
}

class _InvoiceCreatePageState extends State<InvoiceCreatePage> {
  String? selectedClient;
  DateTime selectedDate = DateTime.now();
  final List<Map<String, dynamic>> items = [];

  double get total => items.fold(
    0,
        (sum, item) => sum + (item['qty'] * item['price']),
  );
  //ao
  void addItem() {
    setState(() {
      items.add({
        'name': 'Service',
        'qty': 1,
        'price': 0.0,
      });
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void selectClient() async {
    final client = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _ClientSelector(),
    );

    if (client != null) {
      setState(() => selectedClient = client);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une facture"),
        elevation: 0,
      ),
      //ao
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// CLIENT
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  selectedClient ?? "Sélectionner un client",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selectedClient == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: selectClient,
              ),
            ),

            const SizedBox(height: 16),

            /// DATE
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: selectDate,
              ),
            ),

            const SizedBox(height: 24),

            /// ITEMS
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [

                        TextFormField(
                          initialValue: item['name'],
                          decoration: const InputDecoration(
                            labelText: "Description",
                          ),
                          onChanged: (value) {
                            item['name'] = value;
                          },
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [

                            Expanded(
                              child: TextFormField(
                                initialValue: item['qty'].toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Quantité",
                                ),
                                onChanged: (value) {
                                  item['qty'] =
                                      int.tryParse(value) ?? 1;
                                  setState(() {});
                                },
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: TextFormField(
                                initialValue:
                                item['price'].toString(),
                                keyboardType:
                                TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: const InputDecoration(
                                  labelText: "Prix",
                                ),
                                onChanged: (value) {
                                  item['price'] =
                                      double.tryParse(value) ?? 0.0;
                                  setState(() {});
                                },
                              ),
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  removeItem(index),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Sous-total: ${(item['qty'] * item['price']).toStringAsFixed(2)} €",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            /// TOTAL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${total.toStringAsFixed(2)} €",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedClient == null
                    ? null
                    : () {
                  // TODO: save invoice
                },
                child: const Text("Enregistrer la facture"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientSelector extends StatelessWidget {
  final List<String> clients = [
    "Client A",
    "Client B",
    "Client C",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(clients[index]),
          onTap: () {
            Navigator.pop(context, clients[index]);
          },
        );
      },
    );
  }
}