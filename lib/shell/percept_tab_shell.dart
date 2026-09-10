import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// The 6-tab iOS shell: Today · Learn · Practice · Library · Cases ·
/// Profile. Each tab keeps its own independent navigation stack via
/// [StatefulShellRoute.indexedStack] (state/scroll position is preserved
/// when switching tabs).
class PerceptTabShell extends StatelessWidget {
  const PerceptTabShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.sun_max),
            activeIcon: Icon(CupertinoIcons.sun_max_fill),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            activeIcon: Icon(CupertinoIcons.book_fill),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bolt),
            activeIcon: Icon(CupertinoIcons.bolt_fill),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder),
            activeIcon: Icon(CupertinoIcons.folder_fill),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            activeIcon: Icon(CupertinoIcons.search),
            label: 'Cases',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) => navigationShell,
    );
  }
}
