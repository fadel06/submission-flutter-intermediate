import 'package:flutter/material.dart';
import 'package:submission_flutter_intermediate/db/auth_repository.dart';
import 'package:submission_flutter_intermediate/screen/form_screen.dart';

import '../screen/login_screen.dart';
import '../screen/quote_detail_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/story_detail_screen.dart';
import '../screen/story_list_screen.dart';

class MyRouteDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;
  bool isForm = false;

  MyRouteDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  String? selectedStory;
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool? isRegister = false;
  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        selectedStory = null;
        isForm = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];
  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];
  List<Page> get _loggedInStack => [
        MaterialPage(
            key: const ValueKey("StoryListScreen"),
            child: StoryListScreen(
              onTapped: (String storyId) {
                selectedStory = storyId;
                notifyListeners();
              },
            )),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: StoryDetailScreen(
              storyId: selectedStory!,
            ),
          ),
        if (isForm)
          MaterialPage(
            key: const ValueKey("FormScreen"),
            child: FormScreen(
              onSend: () {
                isForm = false;
                notifyListeners();
              },
            ),
          ),
      ];
  // List<Page> get _loggedInStack => [
  //       MaterialPage(
  //         key: const ValueKey("QuotesListPage"),
  //         child: QuoteListScreen(
  //           quotes: quotes,
  //           onTapped: (String quoteId) {
  //             selectedQuote = quoteId;
  //             notifyListeners();
  //           },
  //           onLogout: () {
  //             isLoggedIn = false;
  //             notifyListeners();
  //           },
  //           toFormScreen: () {
  //             isForm = true;
  //             notifyListeners();
  //           },
  //         ),
  //       ),
  //       if (selectedQuote != null)
  //         MaterialPage(
  //           key: ValueKey(selectedQuote),
  //           child: QuoteDetailsScreen(
  //             quoteId: selectedQuote!,
  //           ),
  //         ),
  //       if (isForm)
  //         MaterialPage(
  //           key: const ValueKey("FormScreen"),
  //           child: FormScreen(
  //             onSend: () {
  //               isForm = false;
  //               notifyListeners();
  //             },
  //           ),
  //         ),
  //     ];
}
