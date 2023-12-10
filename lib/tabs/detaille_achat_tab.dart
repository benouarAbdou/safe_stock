import 'package:flutter/material.dart';

import '../DataBase/myDataBase.dart';

class DetailsAchat extends StatefulWidget {
  const DetailsAchat({super.key});

  @override
  State<DetailsAchat> createState() => _DetailsAchatState();
}

class _DetailsAchatState extends State<DetailsAchat> {
  List<Map<String, dynamic>> selectedAchat = [];
  List<Map<String, dynamic>> selectedAchatDetails = [];
  List<Map<String, dynamic>> operationAchat = [];

  SqlDb sqlDb = SqlDb();

  getOperations() async {
    print("called");
    operationAchat = [];
    operationAchat = await sqlDb.readData("SELECT * FROM operationAchat");
    setState(() {});
  }

  getAchats(int id) async {
    print("called");
    selectedAchatDetails = [];
    selectedAchatDetails = await sqlDb
        .readData('''SELECT * FROM achat WHERE "operationAchatId" = $id ''');
    setState(() {});
  }

  List<DataRow> createDataRowsOperationAchat(List<Map<String, dynamic>> list) {
    return list.map((row) {
      return DataRow(
        selected: selectedAchat.any((selectedRow) =>
            selectedRow['operationAchatId'] == row['operationAchatId']),
        onSelectChanged: (isSelected) => setState(() {
          final isAdding = isSelected != null && isSelected;
          selectedAchat = [];
          if (isAdding) {
            selectedAchat.add(row);
            getAchats(row['operationAchatId']);
            print(row);
          } else {
            setState(() {
              selectedAchatDetails = [];
            });
            selectedAchat.removeWhere((selectedRow) =>
                selectedRow['operationAchatId'] == row['operationAchatId']);
          }

          // Close the current dialog when the selection changes
        }),
        cells: [
          DataCell(Text(row['fournisseurId'].toString())),
          DataCell(Text(row['virement'].toString())),
          DataCell(Text(row['totale'].toString())),
        ],
      );
    }).toList();
  }

  List<DataRow> createDataRowsAchatDetails(List<Map<String, dynamic>> list) {
    return list.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row['produitId'].toString())),
          DataCell(Text(row['quantité'].toString())),
          DataCell(Text(row['prix'].toString())),
          DataCell(Text(row['totale'].toString())),
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    getOperations();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DataTable(
            onSelectAll: (isSelectedAll) {
              setState(() => selectedAchat = []);
            },
            dataRowHeight: 36,
            dataTextStyle: const TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
            columns: const [
              DataColumn(label: Text('fournisseur')),
              DataColumn(label: Text('virement')),
              DataColumn(label: Text('totale')),
            ],
            rows: createDataRowsOperationAchat(
                operationAchat), // Pass the context here
          ),
        ),
        Expanded(
          child: DataTable(
            onSelectAll: (isSelectedAll) {
              setState(() => selectedAchat = []);
            },
            dataRowHeight: 36,
            dataTextStyle: const TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
            columns: const [
              DataColumn(label: Text('Produit id')),
              DataColumn(label: Text('quantité')),
              DataColumn(label: Text('prix')),
              DataColumn(label: Text('totale')),
            ],
            rows: createDataRowsAchatDetails(
                selectedAchatDetails), // Pass the context here
          ),
        )
      ],
    );
  }
}
