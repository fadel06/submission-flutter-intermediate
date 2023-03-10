import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_flutter_intermediate/api/api_service.dart';
import 'package:submission_flutter_intermediate/db/auth_repository.dart';
import 'package:submission_flutter_intermediate/provider/auth_provider.dart';
import 'package:submission_flutter_intermediate/provider/story_create_provider.dart';
import 'package:submission_flutter_intermediate/provider/story_list_provider.dart';
import 'package:submission_flutter_intermediate/routes/page_manager.dart';
import 'package:submission_flutter_intermediate/routes/route_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouteDelegate myRouteDelegate;
  late AuthProvider authProvider;
  final authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();

    authProvider = AuthProvider(authRepository, ApiService());

    myRouteDelegate = MyRouteDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authProvider,
        ),
        ChangeNotifierProvider(create: (context) => PageManager()),
        ChangeNotifierProvider(
            create: (context) => StoryListProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (context) => StoryCreateProvider(ApiService())),
      ],
      child: MaterialApp(
        title: 'Story App',
        home: Router(
          routerDelegate: myRouteDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
