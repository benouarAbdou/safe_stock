import 'package:flutter/material.dart';

import '../Components/contact.dart';
import '../Components/stat_box.dart';
import '../DataBase/myDataBase.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> products = [];

  SqlDb sqlDb = SqlDb();

  getProducts() async {
    print("called");
    products = [];
    products = await sqlDb.readData("SELECT * FROM produit");
    setState(() {});
  }

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
            alignment: Alignment.centerRight,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                StatBox(
                  icon: Icons.shopping_cart,
                  name: "Produits",
                  number: 10,
                ),
                StatBox(
                  icon: Icons.wallet,
                  name: "Transactions",
                  number: 10,
                ),
                StatBox(
                  icon: Icons.person,
                  name: "Client",
                  number: 10,
                ),
                StatBox(
                  icon: Icons.person_2,
                  name: "Fournisseur",
                  number: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Liste des produits",
                                        style: TextStyle(
                                          color: Color(0xff585858),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    GestureDetector(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xff4e55ac)),
                                        child: const Text(
                                          "Voir tout",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                        dataRowHeight: 36,
                                        dataTextStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        columns: const [
                                          DataColumn(
                                              label: Text('Product Name')),
                                          DataColumn(label: Text('Price')),
                                          DataColumn(label: Text('Quantity')),
                                        ],
                                        rows: products.map((row) {
                                          double quantity =
                                              row['produitQuantité'];
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(row['produitNom'])),
                                              DataCell(Text(row['produitPrix']
                                                  .toString())),
                                              DataCell(Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: quantity > 20
                                                        ? Colors.greenAccent
                                                        : (quantity >= 10 &&
                                                                quantity <= 20)
                                                            ? Colors
                                                                .orangeAccent
                                                            : Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  row['produitQuantité']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Contact()
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Dernier transactions",
                                          style: TextStyle(
                                            color: Color(0xff585858),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xff4e55ac)),
                                        child: const Text(
                                          "Voir tout",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Table(
                                    border: TableBorder.all(),
                                    children: const [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Nom'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Prix'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Quantité'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Item 1'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('\$10'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('5'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Item 2'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('\$15'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('3'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Item 3'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('\$20'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('8'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
