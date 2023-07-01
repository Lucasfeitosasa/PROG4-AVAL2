import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/apod_data.dart';
import '../model/favorite_state.dart';

class AstroPicture extends StatelessWidget {
  final ApodData apodData;

  const AstroPicture({Key? key, required this.apodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteState = Provider.of<FavoriteState>(context);
    final isFavorite = favoriteState.favoriteList.contains(apodData);

    void toggleFavorite() {
      if (isFavorite) {
        favoriteState.removeFromList(apodData);
      } else {
        favoriteState.addToList(apodData);
      }
    }

    void openImageDetails(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDetailsScreen(apodData: apodData),
        ),
      );
    }

    return Stack(
      children: [
        InkWell(
          onTap: () => openImageDetails(context),
          child: Image.network(apodData.url, fit: BoxFit.fitWidth),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.grey,
            ),
            onPressed: toggleFavorite,
          ),
        ),
      ],
    );
  }
}

class ImageDetailsScreen extends StatelessWidget {
  final ApodData apodData;

  const ImageDetailsScreen({Key? key, required this.apodData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Imagem'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(apodData.url, fit: BoxFit.fitWidth),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apodData.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(apodData.date),
                    const SizedBox(height: 8),
                    Text(apodData.desc),
                    if (apodData.isFavorite) ...[
                      const SizedBox(height: 8),
                      Text(
                        '© ${apodData.isFavorite}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
