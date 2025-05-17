import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

void main() => runApp(const AdaptiveDemo());

class AdaptiveDemo extends StatelessWidget {
  const AdaptiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<String> _items = List<String>.generate(20, (i) => 'Acara Kampus #${i + 1}');

  @override
  Widget build(BuildContext context) {
    final destinations = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
      const NavigationDestination(icon: Icon(Icons.event), label: 'Acara'),
      const NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
    ];

    return Scaffold(
      body: AdaptiveScaffold(
        selectedIndex: _selectedIndex,
        onSelectedIndexChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: destinations,
        internalAnimations: false, // opsional
        smallBody: (_) => _FeedGrid(cols: 1, items: _items),
        body: (context) {
          final width = MediaQuery.of(context).size.width;
          final cols = width < 905 ? 2 : 3;
          return _FeedGrid(cols: cols, items: _items);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70), // <<< Tambahan untuk naikkan FAB
        child: _buildAdaptiveFab(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // <<< Posisi FAB
    );
  }

  Widget _buildAdaptiveFab(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600; // Batasan sederhana tablet

    if (isTablet) {
      return FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Tambah Acara'),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );
    }
  }
}

class _FeedGrid extends StatelessWidget {
  const _FeedGrid({required this.cols, required this.items});
  final int cols;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: cols == 1 ? 5 : 3 / 2,
      ),
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          child: Center(
            child: Text(
              items[index],
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
