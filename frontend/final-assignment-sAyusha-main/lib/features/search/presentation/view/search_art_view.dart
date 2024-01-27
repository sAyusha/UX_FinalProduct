import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/features/art_details/presentation/view/art_details/art_details_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/app_color_constant.dart';
import '../viewmodel/search_viewmodel.dart';

class SearchArtView extends ConsumerStatefulWidget {
  const SearchArtView({super.key});

  @override
  ConsumerState<SearchArtView> createState() => _SearchArtViewState();
}

class _SearchArtViewState extends ConsumerState<SearchArtView> {
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search Art'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColorConstant.mainSecondaryColor,
                      borderRadius: BorderRadius.circular(29.0),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                                ref
                                    .watch(searchViewModelProvider.notifier)
                                    .getSearchedArts(searchText);
                              });
                            },
                            decoration: const InputDecoration(
                              hintText:
                                  "Search arts using title, creator or category",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (searchState.error != null)
              Center(
                child: Text(
                  searchState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (searchText.isEmpty)
              // If searchText is empty, show nothing.
              Container()
            else if (searchState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (searchState.searchedArts.isEmpty)
              const Center(child: Text('No arts found'))
            else
              // show searched arts only
              Expanded(
                child: ListView.builder(
                  itemCount: searchState.searchedArts.length,
                  itemBuilder: (context, index) {
                    final art = searchState.searchedArts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtDetailsView(art: art),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(art.title),
                        subtitle: Text(art.creator),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
