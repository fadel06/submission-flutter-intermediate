import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_intermediate/provider/story_detail_provider.dart';
import 'package:submission_flutter_intermediate/screen/widgets/error_view.dart';
import 'package:submission_flutter_intermediate/screen/widgets/loading_view.dart';

import '../api/api_service.dart';
import '../utils/constant.dart';

class StoryDetailScreen extends StatelessWidget {
  final String storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoryDetailProvider>(
      create: (_) => StoryDetailProvider(apiService: ApiService(), id: storyId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail Story"),
        ),
        body: Consumer<StoryDetailProvider>(builder: (ctx, provider, _) {
          if (provider.state == ResultState.loading) {
            return const LoadingView(message: "Memuat, mohon menunggu");
          } else if (provider.state == ResultState.error) {
            return const ErrorView(
                message: "Gagal Memuat, Periksa Koneksi Anda");
          } else {
            final story = provider.story.story;
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.0,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(story.photoUrl),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('author : ${story.name}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .apply(
                                    color: Colors.redAccent,
                                    fontStyle: FontStyle.italic)),
                        Text(
                            'Created At : ${story.createdAt.hour} : ${story.createdAt.minute}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Text(story.description,
                      style: Theme.of(context).textTheme.bodySmall!.apply(
                          color: Colors.black, fontStyle: FontStyle.normal))
                ],
              ),
            ));
          }
        }),
      ),
    );
  }
}
