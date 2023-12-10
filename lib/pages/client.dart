import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/material.dart';
import 'package:safe_stock/pages/products.dart';

import '../DataBase/myDataBase.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ntelController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  List<Map<String, dynamic>> clients = [];

  SqlDb sqlDb = SqlDb();

  getClients() async {
    print("called");
    clients = [];
    clients = await sqlDb.readData("SELECT * FROM client");
    setState(() {});
  }

  List<DataRow> createDataRows(List<Map<String, dynamic>> clients) {
    return clients.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row['clientId'].toString())),
          DataCell(Text(row['clientName'])),
          DataCell(Text(row['clientNtel'])),
          DataCell(Text(row['clientAdresse'])),
          DataCell(Text(row['clientTotale'].toString())),
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    getClients();
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
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
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
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Liste des priduits"),
                  GestureDetector(
                    onTap: () {
                      BuildContext mainContext =
                          context; // Store the main context

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
                                            label: "codebar",
                                            hint: "codebar",
                                            controller: nameController,
                                          ),
                                          DialogTextField(
                                            label: "Nom",
                                            hint: "Nom",
                                            controller: ntelController,
                                          ),
                                          DialogTextField(
                                            label: "prix achat",
                                            hint: "prix achat",
                                            controller: adresseController,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: GestureDetector(
                                              onTap: () async {
                                                print("tick");
                                                String name =
                                                    nameController.text;
                                                String ntel =
                                                    ntelController.text;
                                                String adresse =
                                                    adresseController.text;

                                                int response =
                                                    await sqlDb.insertData(
                                                  "INSERT INTO client (clientName, clientNtel, clientAdresse) VALUES ('$name', '$ntel', '$adresse')",
                                                );

                                                Navigator.pop(
                                                    dialogContext); // Use dialogContext to dismiss the dialog
                                                getClients();
                                                print(response);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              width: double.infinity,
              child: CrossScroll(
                child: DataTable(
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
                    rows: createDataRows(clients)),
              ),
            ))
          ],
        ));
  }
}
