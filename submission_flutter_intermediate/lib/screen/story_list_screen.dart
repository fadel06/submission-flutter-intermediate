import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_intermediate/data/model/story.dart';
import 'package:submission_flutter_intermediate/provider/story_list_provider.dart';
import 'package:submission_flutter_intermediate/screen/widgets/error_view.dart';
import 'package:submission_flutter_intermediate/screen/widgets/loading_view.dart';
import 'package:submission_flutter_intermediate/screen/widgets/story_card.dart';

import '../provider/auth_provider.dart';
// import '../routes/page_manager.dart';
import '../routes/page_manager.dart';
import '../utils/constant.dart';

class StoryListScreen extends StatelessWidget {
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() toFormScreen;

  const StoryListScreen({
    Key? key,
    required this.onTapped,
    required this.toFormScreen,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        actions: [
          IconButton(
              onPressed: () async {
                final pageManager = context.read<PageManager>();
                toFormScreen();
                final dataString = await pageManager.waitForResult();
                scaffoldMessengerState.showSnackBar(
                  SnackBar(content: Text(dataString)),
                );
              },
              icon: const Icon(Icons.add_rounded))
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) onLogout();
        },
        tooltip: "Logout",
        child: authWatch.isLoadingLogout
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.logout),
      ),
    );
  }
}
