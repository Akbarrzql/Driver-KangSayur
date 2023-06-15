import 'package:driver_kangsayur/ui/bottom_navigation/item/chat.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat.dart';
import 'package:flutter/material.dart';
import '../../common/color_value.dart';


class BottomNavigation extends StatefulWidget {
  final int currentIndex;

  const BottomNavigation({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List _pageStack = [];

  final _tabs = [
    const HomePage(),
    const ChatPage(),
    const RiwayatPage(),
    const ProfilePage(),
  ];

  void _pagePush(int i) {
    if (_pageStack.isEmpty) {
      _pageStack.add(_currentIndex);
    }
    if (i == _currentIndex) {
      return;
    }
    if (!_pageStack.contains(_currentIndex)) {
      _pageStack.add(_currentIndex);
    }

    setState(() {
      _currentIndex = i;
    });
  }

  Future<bool> _pagePop(BuildContext context) {
    if (_pageStack.isEmpty) {
      return Future<bool>.value(true);
    } else {
      int t = _pageStack.removeLast();
      setState(() {
        _currentIndex = (_currentIndex != t) ? t : _pageStack.removeLast();
      });
      return Future<bool>.value(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () => _pagePop(context),
      child: Scaffold(
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              activeIcon: Icon(
                Icons.local_shipping,
                color: ColorValue.primaryColor,
              ),
              label: 'Pengiriman',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(
                Icons.chat,
                color: ColorValue.primaryColor,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(
                Icons.receipt_long,
                color: ColorValue.primaryColor,
              ),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(
                Icons.person,
                color: ColorValue.primaryColor,
              ),
              label: 'Profil',
            ),
          ],
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor:  ColorValue.primaryColor,
          unselectedItemColor: ColorValue.hintColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: textTheme.bodyText2,
          unselectedLabelStyle: textTheme.bodyText2,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          elevation: 5,
          onTap: (index) {
            _pagePush(index);
          },
        ),
      ),
    );
  }
}
