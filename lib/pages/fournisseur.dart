import 'package:flutter/material.dart';

import '../DataBase/myDataBase.dart';
import '../tabs/ajouter_achat_tab.dart';
import '../tabs/detaille_achat_tab.dart';
import '../tabs/fournisseur_tab.dart';

class Fournisseur extends StatefulWidget {
  const Fournisseur({super.key});

  @override
  State<Fournisseur> createState() => _FournisseurState();
}

class _FournisseurState extends State<Fournisseur>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController ntelController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController totaleController = TextEditingController();
  TextEditingController virementController = TextEditingController();
  late TabController _controller;
  List<Map<String, dynamic>> fournisseur = [];

  List<Map<String, dynamic>> selectedFournisseur = [];
  int totaleMoney = 0;
  int fournisseurId = 0;
  int fournisseurTotale = 0;

  SqlDb sqlDb = SqlDb();

  getfournisseurs() async {
    print("called");
    fournisseur = [];
    fournisseur = await sqlDb.readData("SELECT * FROM fournisseur");
    setState(() {});
  }

  List<DataRow> createDataRowsFournisseur(List<Map<String, dynamic>> list) {
    return list.map((row) {
      int totale = row['fournisseurTotale'];
      return DataRow(
        selected: selectedFournisseur.any((selectedRow) =>
            selectedRow['fournisseurId'] == row['fournisseurId']),
        onSelectChanged: (isSelected) => setState(() {
          final isAdding = isSelected != null && isSelected;
          selectedFournisseur = [];
          if (isAdding) {
            selectedFournisseur.add(row);
            fournisseurId = row['fournisseurId'] as int;
            fournisseurTotale = row['fournisseurTotale'] as int;
          } else {
            selectedFournisseur.removeWhere((selectedRow) =>
                selectedRow['fournisseurId'] == row['fournisseurId']);
          }
          print(row);
          print("valid : ${selectedFournisseur.contains(row)}");
        }),
        cells: [
          DataCell(Text(row['fournisseurId'].toString())),
          DataCell(Text(row['fournisseurName'])),
          DataCell(Text(row['fournisseurNtel'])),
          DataCell(Text(row['fournisseurAdresse'])),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: totale >= 0 ? Colors.greenAccent : Colors.redAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                row['fournisseurTotale'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          /*DataCell(GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(color: Colors.greenAccent),
              child: const Text("ajouter achat"),
            ),
          )),*/
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    virementController.text = "0";

    getfournisseurs();

    _controller = TabController(length: 3, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 10,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Name"),
                ],
              ),
            ),
          ),
          TabBar(
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.bold), // Custom text size for selected tab

            labelPadding: EdgeInsets.zero, // Add padding around the label
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _controller,
            tabs: const [
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: Icon(Icons.person),
                text: 'Fournisseur',
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: Icon(Icons.shopping_basket),
                text: 'Achat',
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: Icon(Icons.inventory),
                text: 'Ajouter Achat',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: const <Widget>[
                FournisseurTab(), // Replace with appropriate widget for Address tab
                DetailsAchat(), // Replace with appropriate widget for Location tab
                AjouterAchat(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
