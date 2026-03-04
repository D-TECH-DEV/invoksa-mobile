import "package:flutter/material.dart";

class ClientTable extends StatefulWidget {
  const ClientTable({super.key});

  @override
  _ClientTableState createState() => _ClientTableState();
}

class _ClientTableState extends State<ClientTable> {
  bool sortAscending = true;
  int? sortColumnIndex;

  List<Map<String, dynamic>> clients = [
    {"name": "Ali", "amount": 2000},
    {"name": "Brice", "amount": 5000},
    {"name": "Charles", "amount": 1000},
  ];

  void sortData(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;

      if (columnIndex == 0) {
        clients.sort((a, b) =>
        ascending ? a["name"].compareTo(b["name"])
            : b["name"].compareTo(a["name"]));
      } else {
        clients.sort((a, b) =>
        ascending ? a["amount"].compareTo(b["amount"])
            : b["amount"].compareTo(a["amount"]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      columns: [
        DataColumn(
          label: Text("Nom"),
          onSort: sortData,
        ),
        DataColumn(
          label: Text("Montant"),
          numeric: true,
          onSort: sortData,
        ),
      ],
      rows: clients.map((client) {
        return DataRow(cells: [
          DataCell(Text(client["name"])),
          DataCell(Text(client["amount"].toString())),
        ]);
      }).toList(),
    );
  }
}