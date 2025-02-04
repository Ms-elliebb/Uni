import 'package:flutter/material.dart';
import 'package:uni/models/app_model.dart';
import 'package:uni/screens/summary_screen.dart';
import 'package:uni/services/app_service.dart';
import 'package:uni/widgets/app_list_item.dart';


class HomeScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Uni App - Ana Ekran'),
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
                child: Text('Ada Göre Sırala'),
              ),
              PopupMenuItem(
                value: 'size',
                child: Text('Boyuta Göre Sırala'),
              ),
              PopupMenuItem(
                value: 'lastUsed',
                child: Text('Son Kullanım Tarihine Göre Sırala'),
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Uygulama Ara',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
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