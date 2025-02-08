import 'package:flutter/material.dart';
import 'package:uni/models/app_model.dart';
import 'package:uni/screens/summary_screen.dart';
import 'package:uni/services/app_service.dart';
import 'package:uni/widgets/app_list_item.dart';
import '../languages/app_localizations.dart';
import 'package:uni/theme/app_theme.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AppModel> apps = [];
  List<AppModel> filteredApps = [];
  List<AppModel> selectedApps = [];
  String searchQuery = '';
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    loadApps();
  }

  void loadApps() async {
    final appService = AppService();
    final loadedApps = await appService.getInstalledApps();
    setState(() {
      apps = loadedApps;
      filteredApps = loadedApps;
      sortApps();
    });
  }

  void toggleSelection(AppModel app) {
    setState(() {
      if (selectedApps.contains(app)) {
        selectedApps.remove(app);
      } else {
        selectedApps.add(app);
      }
    });
  }

  void uninstallApps() async {
    final appService = AppService();
    final failedUninstalls = <String>[];
    for (final app in selectedApps) {
      try {
        await appService.uninstallApp(app.packageName);
      } catch (e) {
        failedUninstalls.add(app.name);
      }
    }
    setState(() {
      selectedApps.clear();
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          uninstalledCount: selectedApps.length - failedUninstalls.length,
          failedUninstalls: failedUninstalls,
        ),
      ),
    );
  }

  void filterApps(String query) {
    setState(() {
      searchQuery = query;
      filteredApps = apps.where((app) {
        return app.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      sortApps();
    });
  }

  void sortApps() {
    setState(() {
      switch (sortBy) {
        case 'name':
          filteredApps.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'size':
          filteredApps.sort((a, b) => b.size.compareTo(a.size));
          break;
        case 'lastUsed':
          filteredApps.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('appName')),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: uninstallApps,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortBy = value;
                sortApps();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'name',
                child: Text(localizations.translate('sortByName')),
              ),
              PopupMenuItem(
                value: 'size',
                child: Text(localizations.translate('sortBySize')),
              ),
              PopupMenuItem(
                value: 'lastUsed',
                child: Text(localizations.translate('sortByLastUsed')),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: localizations.translate('searchApps'),
                prefixIcon: Icon(Icons.search, color: AppTheme.lightTextColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onChanged: filterApps,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredApps.length,
              itemBuilder: (context, index) {
                final app = filteredApps[index];
                return AppListItem(
                  app: app,
                  isSelected: selectedApps.contains(app),
                  onTap: () => toggleSelection(app),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}