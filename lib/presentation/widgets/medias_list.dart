import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movi_mobile/presentation/widgets/cover.dart';

class MediasList extends StatelessWidget {
  final String title;
  final dynamic medias;
  const MediasList({super.key, required this.medias, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 249,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: medias.isNotEmpty ? medias.length : 0,
              itemBuilder: (context, index) {
                if (medias == null || medias.isEmpty) {
                  return const SizedBox(
                    height: 239,
                    child: Center(
                      child: Text(
                        'Aucun média disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                } else if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 10),
                    child: Cover(media: medias[index]),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Cover(media: medias[index]),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
