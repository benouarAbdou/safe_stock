import 'package:flutter/material.dart';
import 'package:safe_stock/pages/client.dart';
import 'package:safe_stock/pages/dashboard.dart';
import 'package:safe_stock/pages/fournisseur.dart';
import 'package:safe_stock/pages/products.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI
  sqfliteFfiInit();

  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    const Dashboard(),
    const Dashboard(),
    const Products(),
    const Products(),
    const Fournisseur(),
    const ClientPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f2ff),
      body: Row(
        children: [
          Expanded(
            child: NavigationRail(
              minWidth: 120,
              indicatorColor: Colors.blueAccent,
              selectedIconTheme: const IconThemeData(color: Colors.white),
              selectedLabelTextStyle: const TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              labelType: NavigationRailLabelType.all,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Acceuil'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.wallet_outlined),
                  selectedIcon: Icon(Icons.wallet),
                  label: Text('Transactions'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_cart),
                  selectedIcon: Icon(Icons.shopping_cart_outlined),
                  label: Text('Produit'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.attach_money),
                  selectedIcon: Icon(Icons.attach_money_outlined),
                  label: Text('Crédit'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_2),
                  selectedIcon: Icon(Icons.person_2_outlined),
                  label: Text('Fournisseur'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  selectedIcon: Icon(Icons.person_outline),
                  label: Text('Client'),
                ),
              ],
            ),
          ),

          pages[_selectedIndex]

          // here start content
        ],
      ),
    );
  }
}
