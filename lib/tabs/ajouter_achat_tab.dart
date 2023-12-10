import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import '../DataBase/myDataBase.dart';

class AjouterAchat extends StatefulWidget {
  const AjouterAchat({super.key});

  @override
  State<AjouterAchat> createState() => _AjouterAchatState();
}

class _AjouterAchatState extends State<AjouterAchat> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController achatController = TextEditingController();
  TextEditingController venteController = TextEditingController();
  TextEditingController virementController = TextEditingController();
  double totale = 0;
  int achatCounter = 0;

  List<Map<String, dynamic>> fournisseur = [];
  List<Map<String, dynamic>> produit = [];
  List<Map<String, dynamic>> selectedFournisseur = [];
  List<Map<String, dynamic>> selectedProduit = [];
  List<Map<String, dynamic>> achat = [];

  SqlDb sqlDb = SqlDb();

  getfournisseurs() async {
    print("called");
    fournisseur = [];
    fournisseur = await sqlDb.readData("SELECT * FROM fournisseur");
    setState(() {});
  }

  getProduit() async {
    print("called");
    produit = [];
    produit = await sqlDb.readData("SELECT * FROM produit");
    setState(() {});
  }

  List<DataRow> createDataRowsFournisseur(
      List<Map<String, dynamic>> list, BuildContext context) {
    return list.map((row) {
      double totale = row['fournisseurTotale'];
      return DataRow(
        selected: selectedFournisseur.any((selectedRow) =>
            selectedRow['fournisseurId'] == row['fournisseurId']),
        onSelectChanged: (isSelected) => setState(() {
          final isAdding = isSelected != null && isSelected;
          selectedFournisseur = [];
          if (isAdding) {
            selectedFournisseur.add(row);
          } else {
            selectedFournisseur.removeWhere((selectedRow) =>
                selectedRow['fournisseurId'] == row['fournisseurId']);
          }
          print(row);
          print("valid : ${selectedFournisseur.contains(row)}");

          // Close the current dialog when the selection changes
          Navigator.pop(context);
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
        ],
      );
    }).toList();
  }

  List<DataRow> createDataRowsProduit(
      List<Map<String, dynamic>> list, BuildContext context) {
    return list.map((row) {
      double quantity = row['produitQuantité'];

      return DataRow(
        selected: selectedProduit
            .any((selectedRow) => selectedRow['produitId'] == row['produitId']),
        onSelectChanged: (isSelected) => setState(() {
          final isAdding = isSelected != null && isSelected;
          selectedProduit = [];
          if (isAdding) {
            selectedProduit.add(row);
          } else {
            selectedProduit.removeWhere(
                (selectedRow) => selectedRow['produitId'] == row['produitId']);
          }
          print(row);
          print("valid : ${selectedFournisseur.contains(row)}");

          // Close the current dialog when the selection changes
          Navigator.pop(context);
        }),
        cells: [
          DataCell(Text(row['produitId'].toString())),
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
        ],
      );
    }).toList();
  }

  List<DataRow> createDataRowsAchat(List<Map<String, dynamic>> list) {
    return list.map((row) {
      int achatId = row['AchatId'];

      return DataRow(
        cells: [
          DataCell(Text(row['ProduitNom'])),
          DataCell(Text(row['PrixAchat'].toString())),
          DataCell(Text(row['PrixVente'].toString())),
          DataCell(Text(row['Quantité'].toString())),
          DataCell(Text(row['PrixTotale'].toString())),
          DataCell(GestureDetector(
            onTap: () {
              print("del call");

              setState(() {
                achat.removeWhere((entry) => entry['AchatId'] == achatId);
              });
            },
            child: Container(child: const Icon(Icons.delete)),
          )),
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    getfournisseurs();
    getProduit();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        height: 500,
                        width: 800,
                        color: Colors.white,
                        child: Center(
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
                            rows: createDataRowsFournisseur(
                                fournisseur, context), // Pass the context here
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: selectedFournisseur.isEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text("Choisir un fournisseur"),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(selectedFournisseur[0]['fournisseurName']),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            height: 500,
                            width: 800,
                            color: Colors.white,
                            child: Center(
                              child: DataTable(
                                onSelectAll: (isSelectedAll) {
                                  setState(() => selectedProduit = []);
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
                                rows: createDataRowsProduit(
                                    produit, context), // Pass the context here
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: selectedProduit.isEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Text("Choisir un produit"),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(selectedProduit[0]['produitNom']),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xfff4f2ff),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      border: InputBorder.none,
                      hintText: "Quantité",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: achatController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xfff4f2ff),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      border: InputBorder.none,
                      hintText: "Prix Achat",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: venteController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xfff4f2ff),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      border: InputBorder.none,
                      hintText: "Prix Vente",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (selectedProduit.isEmpty) {
                      showSnackbarError(2, "oops", "choisir in produit");
                    } else if (venteController.text.isEmpty ||
                        achatController.text.isEmpty ||
                        quantityController.text.isEmpty) {
                      showSnackbarError(2, "oops", "Remplire tous les champs");
                    } else {
                      achatCounter++;
                      addItemToAchat(
                          achatCounter,
                          selectedProduit[0]['produitId'],
                          selectedProduit[0]['produitNom'],
                          double.parse(venteController.text),
                          double.parse(achatController.text),
                          double.parse(quantityController.text));
                      setState(() {
                        selectedProduit = [];
                      });
                      controllersSetters(0.toString(), 0.toString(),
                          0.toString(), 0.toString());
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: const BoxDecoration(color: Colors.blueAccent),
                      child: const Text("ajouter")),
                )
              ]),
            ))
          ],
        )),
        Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: DataTable(
                      columnSpacing: 30.0,
                      onSelectAll: (isSelectedAll) {
                        setState(() => selectedFournisseur = []);
                      },
                      dataRowHeight: 36,
                      dataTextStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      columns: const [
                        DataColumn(label: Text('Produit Nom')),
                        DataColumn(label: Text('Prix achat')),
                        DataColumn(label: Text('prix vente')),
                        DataColumn(label: Text('quantité')),
                        DataColumn(label: Text('totale')),
                        DataColumn(label: Text('')),
                      ],
                      rows: createDataRowsAchat(achat), // Pass the context here
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (selectedFournisseur.isEmpty) {
                    showSnackbarError(2, "oops", "choisir un fournisseur");
                  } else if (achat.isEmpty) {
                    showSnackbarError(2, "oops", "ajouter au moin un achat");
                  } else if (virementController.text.isEmpty) {
                    showSnackbarError(2, "oops", "ajouter virement");
                  } else {
                    double achatTotale = 0;

                    int userId = 1;
                    int fournisseurId = selectedFournisseur[0]['fournisseurId'];
                    double virement = double.parse(virementController.text);
                    for (int i = 0; i < achat.length; i++) {
                      achatTotale += achat[i]["PrixTotale"];
                    }

                    int id = await sqlDb.insertData(
                      "INSERT INTO operationAchat (fournisseurId,  totale,virement,userId) VALUES ( $fournisseurId,  $achatTotale,$virement,$userId)",
                    );

                    for (var entry in achat) {
                      int produitId = entry["ProduitId"];
                      double quantite = entry["Quantité"];
                      double prixAchat = entry["PrixAchat"];
                      double prixVente = entry["PrixVente"];
                      double totaleProduit = entry["PrixTotale"];
                      int response = await sqlDb.insertData(
                        "INSERT INTO achat (produitId, fournisseurId, quantité, prix, totale,operationAchatId) VALUES ($produitId, $fournisseurId, $quantite, $prixAchat, $totaleProduit,$id)",
                      );
                      await getProduit();
                      print(produit);
                      print(response);

                      double newQuantity = quantite +
                          produit
                              .where((product) =>
                                  product['produitId'] == produitId)
                              .first['produitQuantité'];
                      print('newq : $newQuantity');

                      int r3 = await sqlDb.updateData(
                          '''UPDATE "produit" SET "produitQuantité" = $newQuantity , "produitPrix" = $prixVente, "prixAchat"= $prixAchat WHERE "produitId" = $produitId''');
                    }
                    double newTotale = achatTotale -
                        virement +
                        selectedFournisseur[0]['fournisseurTotale'];

                    int r2 = await sqlDb.updateData(
                        '''UPDATE "fournisseur"SET "fournisseurTotale" = $newTotale WHERE "fournisseurId" = $fournisseurId''');

                    setState(() {
                      achat = [];
                      totale = 0;
                    });
                    controllersSetters(
                        0.toString(), 0.toString(), 0.toString(), 0.toString());
                    showSnackbarError(1, "yaay", "achat ajouté");
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: virementController,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: const BoxDecoration(color: Colors.blueAccent),
                      child: const Text("valider"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void showSnackbarError(int type, String title, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),

      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type == 0
            ? ContentType.failure
            : type == 1
                ? ContentType.success
                : ContentType.warning,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void addItemToAchat(int achatId, int produitId, String produitNom,
      double prixAchat, double prixVente, double quantite) {
    double prixTotale = prixAchat * quantite; // Calculate the total price

    Map<String, dynamic> newItem = {
      'AchatId': achatId,
      'ProduitId': produitId,
      'ProduitNom': produitNom,
      'PrixAchat': prixAchat,
      'PrixVente': prixVente,
      'Quantité': quantite,
      'PrixTotale': prixTotale,
    };

    setState(() {
      achat.add(newItem); // Add the new item to the 'achat' list
    });

    print(achat);
  }

  void controllersSetters(
      String quantity, String achat, String vente, String virement) {
    setState(() {
      quantityController.text = quantity;
      achatController.text = achat;
      venteController.text = vente;
      virementController.text = virement;
    });
  }
}
