import 'package:apod/widgets/astro_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/apod_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({required Key key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Quantidade de Imagens'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, 5);
          },
          child: const Text('5'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, 10);
          },
          child: const Text('10'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, 15);
          },
          child: const Text('15'),
        ),
      ],
    );
  }
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = false;

  void _changeImageCount() {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Quantidade de Imagens'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 5);
              },
              child: const Text('5'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 10);
              },
              child: const Text('10'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 15);
              },
              child: const Text('15'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        final dailyApodState =
            Provider.of<DailyApodState>(context, listen: false);
        dailyApodState.cardCount = value;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchApodData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchApodData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final dailyApodState = Provider.of<DailyApodState>(context, listen: false);

    if (mounted) {
      await dailyApodState.fetchDailyApodData();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await fetchApodData();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = MediaQuery.of(context).size;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isLoading
            ? SizedBox(
                height: deviceScreen.height,
                width: deviceScreen.width,
                child: const Center(child: CircularProgressIndicator()),
              )
            : Consumer<DailyApodState>(
                builder: (context, dailyApodState, child) {
                  final apodList = dailyApodState.dailyApods;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var apodData in apodList)
                          Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  offset: const Offset(0.0, 10.0),
                                  blurRadius: 10.0,
                                  spreadRadius: -6.0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  AstroPicture(apodData: apodData),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            apodData.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            apodData.date,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
