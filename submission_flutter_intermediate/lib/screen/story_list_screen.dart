import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_intermediate/data/model/story.dart';
import 'package:submission_flutter_intermediate/provider/story_list_provider.dart';
import 'package:submission_flutter_intermediate/screen/widgets/error_view.dart';
import 'package:submission_flutter_intermediate/screen/widgets/loading_view.dart';
import 'package:submission_flutter_intermediate/screen/widgets/story_card.dart';

import '../utils/constant.dart';

class StoryListScreen extends StatelessWidget {
  final Function(String) onTapped;

  const StoryListScreen({Key? key, required this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
      ),
      body: Consumer<StoryListProvider>(builder: (ctx, provider, _) {
        if (provider.state == ResultState.loading) {
          return const LoadingView(message: "Menyiapkan rekomendasi story");
        } else if (provider.state == ResultState.error) {
          return const ErrorView(message: 'Gagal Memuat, Periksa Koneksi Anda');
        } else {
          final List<Story> stories = provider.list.listStory;
          return ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    onTapped(stories[index].id);
                  },
                  child: StoryCard(
                    story: stories[index],
                  ),
                );
              });
        }
      }),
    );
  }
}
