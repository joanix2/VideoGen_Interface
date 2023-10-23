import 'package:flutter/material.dart';
import 'package:video_gen_app/projects_menu.dart';
import 'Ads.dart';
import 'Performances.dart';
import 'SEO.dart';
import 'Trends.dart';
import 'config.dart';

class MenuItem {
  final String name;
  final IconData icon;
  final Widget scaffold;

  MenuItem({
    required this.name,
    required this.icon,
    required this.scaffold,
  });

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => scaffold),
    );
  }
}


class CustomDrawer extends StatefulWidget {
  final String token;

  const CustomDrawer({super.key, required this.token});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  late List<MenuItem> menuItems;

  @override
  void initState() {
    super.initState();
    menuItems = [
      MenuItem(
        name: 'Trends',
        icon: Icons.trending_up,
        scaffold: TrendsPage(token: widget.token),
      ),
      MenuItem(
        name: 'SEO',
        icon: Icons.search,
        scaffold: SEOPage(token: widget.token),
      ),
      MenuItem(
        name: 'Projects',
        icon: Icons.work,
        scaffold: ProjectPage(token: widget.token),
      ),
      MenuItem(
        name: 'Advertisement',
        icon: Icons.payment,
        scaffold: AdvertisementPage(token: widget.token),
      ),
      MenuItem(
        name: 'Performance',
        icon: Icons.speed,
        scaffold: PerformancePage(token: widget.token),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 112,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: color1,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          for (var item in menuItems)
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.name),
              onTap: () {
                item.navigate(context);
              },
            ),
        ],
      ),
    );
  }
}