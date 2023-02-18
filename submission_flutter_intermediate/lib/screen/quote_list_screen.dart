import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_intermediate/db/auth_repository.dart';

import '../model/quote.dart';
import '../provider/auth_provider.dart';
import '../routes/page_manager.dart';

class QuotesListScreen extends StatelessWidget {
  final List<Quote> quotes;
  final Function(String) onTapped;
  final Function() toFormScreen;
  final Function() onLogout;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.toFormScreen,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    final authRepository = AuthRepository();
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
                  SnackBar(content: Text("My name is $dataString")),
                );
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: ListView(
        children: [
          for (var quote in quotes)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.quote),
              isThreeLine: true,
              onTap: () async {
                var user = await authRepository.getUser();

                scaffoldMessengerState
                    .showSnackBar(SnackBar(content: Text(user!.name!)));
                onTapped(quote.id);
              },
            )
        ],
      ),
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
