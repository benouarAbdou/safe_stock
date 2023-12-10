import 'package:flutter/material.dart';

import '../DataBase/myDataBase.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  //controllers
  TextEditingController codebarController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  List<Map<String, dynamic>> products = [];
  List<DataRow> createDataRows(List<Map<String, dynamic>> products) {
    return products.map((row) {
      double quantity = row['produitQuantité'];

      return DataRow(
        cells: [
          DataCell(Text(row['produitId'].toString())),
          DataCell(Text(row['codebar'].toString())),
          DataCell(Text(row['produitNom'])),
          DataCell(Text(row['produitPrix'].toString())),
          DataCell(Text(row['prixAchat'].toString())),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: quantity > 20
                    ? Colors.greenAccent
                    : (quantity >= 10 && quantity <= 20)
                        ? Colors.orangeAccent
                        : Colors.redAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                row['produitQuantité'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          DataCell(Text(row['userId'].toString())),
        ],
      );
    }).toList();
  }

  Future<void> getProducts() async {
    print("called");
    products = [];
    products = await sqlDb.readData("SELECT * FROM produit");
    setState(() {});
  }

  SqlDb sqlDb = SqlDb();
  @override
  void initState() {
    getProducts();
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
                                            controller: codebarController,
                                          ),
                                          DialogTextField(
                                            label: "Nom",
                                            hint: "Nom",
                                            controller: nameController,
                                          ),
                                          DialogTextField(
                                            label: "prix achat",
                                            hint: "prix achat",
                                            controller: sellPriceController,
                                          ),
                                          DialogTextField(
                                            label: "Quantité",
                                            hint: "quantité",
                                            controller: quantityController,
                                          ),
                                          DialogTextField(
                                            label: "Prix vente",
                                            hint: "prix vente",
                                            controller: priceController,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: GestureDetector(
                                              onTap: () async {
                                                print("tick");
                                                String produitNom =
                                                    nameController.text;
                                                String codebar =
                                                    codebarController.text;
                                                double produitPrix =
                                                    double.parse(
                                                        priceController.text);
                                                double sellPrix = double.parse(
                                                    sellPriceController.text);
                                                double produitQuantite =
                                                    double.parse(
                                                        quantityController
                                                            .text);
                                                int r = await sqlDb.insertData(
                                                  "INSERT INTO user (userName, userPassword, userType) VALUES ('a','a',1)",
                                                );
                                                int response =
                                                    await sqlDb.insertData(
                                                  "INSERT INTO produit (produitNom, codebar, produitPrix, produitQuantité, userId, prixAchat) VALUES ('$produitNom', '$codebar', $produitPrix, $produitQuantite, 1, $sellPrix)",
                                                );

                                                /*int r = await sqlDb.insertData(
                                                  "INSERT INTO client (clientName, clientNtel, clientAdresse) VALUES ('a','a','aa')",
                                                );*/

                                                Navigator.pop(
                                                    dialogContext); // Use dialogContext to dismiss the dialog
                                                await getProducts();
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
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: DataTable(
                    dataRowHeight: 36,
                    dataTextStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    columns: const [
                      DataColumn(label: Text('Product Id')),
                      DataColumn(label: Text('Codebar')),
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('prix vente')),
                      DataColumn(label: Text('prix achat')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('user')),
                    ],
                    rows: createDataRows(products)),
              ),
            ),
          ],
        ));
  }
}

class DialogTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  const DialogTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xfff4f2ff),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ],
      ),
    );
  }
}
