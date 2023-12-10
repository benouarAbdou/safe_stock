import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/material.dart';

import '../DataBase/myDataBase.dart';
import '../pages/products.dart';

class FournisseurTab extends StatefulWidget {
  const FournisseurTab({super.key});

  @override
  State<FournisseurTab> createState() => _FournisseurTabState();
}

class _FournisseurTabState extends State<FournisseurTab> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ntelController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController totaleController = TextEditingController();
  TextEditingController virementController = TextEditingController();
  List<Map<String, dynamic>> fournisseur = [];

  List<Map<String, dynamic>> selectedFournisseur = [];

  SqlDb sqlDb = SqlDb();

  getfournisseurs() async {
    print("called");
    fournisseur = [];
    fournisseur = await sqlDb.readData("SELECT * FROM fournisseur");
    setState(() {});
  }

  /*getproducts() async {
    print("called");
    products = [];
    products = await sqlDb.readData("SELECT * FROM produit");
    setState(() {});
  }*/

  List<DataRow> createDataRowsFournisseur(List<Map<String, dynamic>> list) {
    return list.map((row) {
      double totale = row['fournisseurTotale'];
      return DataRow(
        /*selected: selectedFournisseur.any((selectedRow) =>
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
        }),*/
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

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Liste des priduits"),
              GestureDetector(
                onTap: () {
                  BuildContext mainContext = context; // Store the main context

                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return Dialog(
                        child: SizedBox(
                          height: 600,
                          width: 700,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(25),
                                  decoration: const BoxDecoration(
                                    color: Color(0xfff4f2ff),
                                  ),
                                  child: Column(children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(25),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text("Ajouter Produits"),
                                      DialogTextField(
                                        label: "Nom de fournisseur",
                                        hint: "Nom de fournisseur",
                                        controller: nameController,
                                      ),
                                      DialogTextField(
                                        label: "Numero de telephone",
                                        hint: "Numero de telephone",
                                        controller: ntelController,
                                      ),
                                      DialogTextField(
                                        label: "adresse",
                                        hint: "adresse",
                                        controller: adresseController,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () async {
                                            print("tick");
                                            String name = nameController.text;
                                            String ntel = ntelController.text;
                                            String adresse =
                                                adresseController.text;

                                            int response =
                                                await sqlDb.insertData(
                                              "INSERT INTO fournisseur (fournisseurName, fournisseurNtel, fournisseurAdresse) VALUES ('$name', '$ntel', '$adresse')",
                                            );

                                            Navigator.pop(
                                                dialogContext); // Use dialogContext to dismiss the dialog
                                            getfournisseurs();
                                            print(response);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Text("ajouter"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.greenAccent,
                  ),
                  child: const Text("Ajouter produit"),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),

                        color: Colors.white, // Set background color explicitly
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        child: CrossScroll(
                          child: DataTable(
                            onSelectAll: (isSelectedAll) {
                              setState(() => selectedFournisseur = []);
                            },
                            dataRowHeight: 36,
                            dataTextStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            columns: const [
                              DataColumn(label: Text('client Id')),
                              DataColumn(label: Text('client Nom')),
                              DataColumn(label: Text('n tel')),
                              DataColumn(label: Text('adresse')),
                              DataColumn(label: Text('totale')),
                            ],
                            rows: createDataRowsFournisseur(fournisseur),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  color: Colors.greenAccent,
                  /*child: Column(
                  children: [
                    Text(
                      "totale : $totaleMoney",
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: DialogTextField(
                        label: "Nom de fournisseur",
                        hint: "Nom de fournisseur",
                        controller: virementController,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        int virement = int.parse(virementController.text);
                        int newTotale = virement - totaleMoney;
                        await sqlDb.updateData('''
  UPDATE "fournisseur"
  SET "fournisseurTotale" = $newTotale
  WHERE "fournisseurId" = $fournisseurId
''');
                        selectedFournisseur = [];
                        selectedproducts = [];
                        totaleMoney = 0;

                        getfournisseurs();
                      },
                      child: Container(
                        color: Colors.red,
                        child: const Text("add"),
                      ),
                    )
                  ],
                ),*/
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
