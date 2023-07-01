import 'package:apod/Pages/navbar.dart';
import 'package:apod/model/favorite_state.dart';
import 'package:apod/pages/favorite_page.dart';
import 'package:apod/pages/main_page.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'material_theme/color_schemes.g.dart';
import 'material_theme/custom_color.g.dart';
import 'model/apod_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();
          lightCustomColors = lightCustomColors.harmonized(lightScheme);

          // Repeat for the dark color scheme.
          darkScheme = darkDynamic.harmonized();
          darkCustomColors = darkCustomColors.harmonized(darkScheme);
        } else {
          // Otherwise, use fallback schemes.
          lightScheme = lightColorScheme;
          darkScheme = darkColorScheme;
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => DailyApodState(),
            ),
            ChangeNotifierProvider(
              create: (context) => FavoriteState(),
            ),
          ],
          child: MaterialApp(
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightScheme,
                extensions: [lightCustomColors],
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkScheme,
                extensions: [darkCustomColors],
              ),
              home: const MyHomePage(),
              debugShowCheckedModeBanner: false),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void showCardCountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quantidade de imagens'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecione a quantidade de imagens:'),
            const SizedBox(height: 16),
            Consumer<DailyApodState>(
              builder: (context, dailyApodState, _) {
                return TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: dailyApodState.cardCount.toString(),
                  onChanged: (value) {
                    final count = int.tryParse(value) ?? 0;
                    dailyApodState.cardCount = count;
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _pages = [
    {
      'widget': const MainPage(
        key: Key('mainPage'),
      ),
    },
    {'widget': const FavoritePage()}
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex < 0 || _selectedIndex >= _pages.length) {
      _selectedIndex = 0;
    }
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: showCardCountDialog,
          ),
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FavoriteState(),
          ),
          ChangeNotifierProvider(create: (context) => DailyApodState())
        ],
        child: _pages[_selectedIndex]['widget'],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favoritos',
          ),
        ],
        currentIndex: _selectedIndex.clamp(0, _pages.length - 1),
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
