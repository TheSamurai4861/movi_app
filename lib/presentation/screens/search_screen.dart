import 'package:flutter/material.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';
import 'package:movi_mobile/core/service_locator.dart';
import 'package:movi_mobile/domain/usecases/movie/search_movie.dart';
import 'package:movi_mobile/presentation/widgets/cover.dart';

class SearchModalContent extends StatefulWidget {
  final ScrollController scrollController;

  const SearchModalContent({super.key, required this.scrollController});

  @override
  State<SearchModalContent> createState() => _SearchModalContentState();
}

class _SearchModalContentState extends State<SearchModalContent> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredMedias = [];

  static const double coverWidth = 133;
  static const double coverHeight = 200;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    String query = _searchController.text.toLowerCase();

    if (query.length >= 3) {
      final usecase = SearchMovie(sl());

      final result = await usecase.call(query);

      result.fold(
        (failure) {
          // Gérer les erreurs ici, par exemple :
          print("Erreur lors de la recherche : $failure");
          setState(() {
            _filteredMedias = []; // Affiche "Aucun résultat" en cas d'erreur
          });
        },
        (movies) {
          setState(() {
            _filteredMedias = movies;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre draggable
        Container(
          width: 40,
          height: 5,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cherchez un film, une série',
              hintStyle: const TextStyle(
                  color: Color.fromARGB(174, 255, 255, 255), fontSize: 16),
              filled: true,
              fillColor: Colors.grey[850],
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredMedias.isEmpty
              ? const Center(
                  child: Text(
                    "Aucun résultat trouvé",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : GridView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: coverWidth / coverHeight,
                  ),
                  itemCount: _filteredMedias.length,
                  itemBuilder: (context, index) {
                    return Cover(media: _filteredMedias[index]);
                  },
                ),
        ),
      ],
    );
  }
}
