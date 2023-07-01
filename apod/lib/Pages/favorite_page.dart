import 'package:apod/model/favorite_state.dart';
import 'package:apod/widgets/astro_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/apod_data.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<FavoriteState>(builder: (context, favoriteState, child) {
        List<ApodData> list = favoriteState.favoriteList;
        return list.isNotEmpty
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 100,
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: 100,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text(list[index].date),
                              ),
                              body: ChangeNotifierProvider.value(
                                value: favoriteState,
                                child: AstroPicture(apodData: list[index]),
                              ),
                            );
                          }));
                        },
                        child: Card(
                            elevation: 5.0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(list[index].date,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400])),
                                  Text(
                                    list[index].title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ])),
                      ),
                    ),
                  );
                },
                itemCount: favoriteState.favoriteList.length,
              )
            : Center(
                child: Text(
                  'não há favoritos!',
                  style: TextStyle(fontSize: 30, color: Colors.grey[400]),
                ),
              );
      }),
    );
  }
}
