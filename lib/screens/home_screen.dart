import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uni/models/app_model.dart';
import 'package:uni/screens/summary_screen.dart';
import 'package:uni/services/app_service.dart';
import 'package:uni/widgets/app_list_item.dart';
import '../languages/app_localizations.dart';
import 'package:uni/widgets/banner_ad_widget.dart';
import 'package:uni/theme/app_colors.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<AppModel> apps = [];
  List<AppModel> filteredApps = [];
  List<AppModel> selectedApps = [];
  String searchQuery = '';
  String sortBy = 'name';
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    loadApps();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Ekrana geri dönüldüğünde uygulama listesini güncelleyelim
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // İlk yükleme sırasında loadApps zaten initState'te çağrılıyor
      // Bu yüzden sadece _isLoading false ise (ilk yüklemeden sonra) yeniden yükleyelim
      if (!_isLoading && mounted) {
        loadApps();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void loadApps() async {
    setState(() {
      _isLoading = true;
    });
    
    final appService = AppService();
    final loadedApps = await appService.getInstalledApps();
    
    if (mounted) {
      setState(() {
        apps = loadedApps;
        filteredApps = loadedApps;
        _isLoading = false;
        sortApps();
      });
      
      _animationController.forward();
    }
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
    final int totalSelected = selectedApps.length;
    
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
    
    // SummaryScreen'den dönüldüğünde uygulamaları yeniden yükleyelim
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          uninstalledCount: totalSelected - failedUninstalls.length,
          failedUninstalls: failedUninstalls,
        ),
      ),
    );
    
    // SummaryScreen'den true değeri ile dönüldüğünde uygulama listesini yenileyelim
    if (shouldRefresh == true) {
      loadApps();
    }
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

  Widget _buildSearchField(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: localizations.translate('searchApps'),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onChanged: filterApps,
      ),
    );
  }

  Widget _buildSortButton(AppLocalizations localizations) {
    IconData sortIcon;
    Color sortIconColor;
    
    switch (sortBy) {
      case 'name':
        sortIcon = Icons.sort_by_alpha;
        sortIconColor = AppColors.primary;
        break;
      case 'size':
        sortIcon = Icons.storage;
        sortIconColor = AppColors.info;
        break;
      case 'lastUsed':
        sortIcon = Icons.access_time;
        sortIconColor = AppColors.success;
        break;
      default:
        sortIcon = Icons.sort;
        sortIconColor = Colors.grey;
    }
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: Icon(sortIcon, color: sortIconColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onSelected: (value) {
          setState(() {
            sortBy = value;
            sortApps();
          });
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'name',
            child: Row(
              children: [
                Icon(Icons.sort_by_alpha, 
                  color: sortBy == 'name' ? AppColors.primary : Colors.grey),
                const SizedBox(width: 10),
                Text(localizations.translate('sortByName')),
                if (sortBy == 'name')
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.check, color: AppColors.primary, size: 16),
                  ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'size',
            child: Row(
              children: [
                Icon(Icons.storage, 
                  color: sortBy == 'size' ? AppColors.info : Colors.grey),
                const SizedBox(width: 10),
                Text(localizations.translate('sortBySize')),
                if (sortBy == 'size')
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.check, color: AppColors.info, size: 16),
                  ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'lastUsed',
            child: Row(
              children: [
                Icon(Icons.access_time, 
                  color: sortBy == 'lastUsed' ? AppColors.success : Colors.grey),
                const SizedBox(width: 10),
                Text(localizations.translate('sortByLastUsed')),
                if (sortBy == 'lastUsed')
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.check, color: AppColors.success, size: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apps_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            localizations.translate('noAppsFound'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty 
                ? localizations.translate('tryDifferentSearch')
                : localizations.translate('refreshApps'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: loadApps,
            icon: const Icon(Icons.refresh),
            label: Text(localizations.translate('refresh')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Uygulamalar yükleniyor...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenSize = MediaQuery.of(context).size;
    
    return WillPopScope(
      onWillPop: () async {
        return true; // Uygulamadan çıkılmasına izin ver
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Arkaplan gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                ),
              ),
            ),
            
            // Üst kısımdaki dekoratif dalgalı şekil
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(screenSize.width, screenSize.height * 0.2),
                painter: CurvePainter(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            
            // Ana içerik
            SafeArea(
              child: Column(
                children: [
                  // Üst kısım - AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo ve başlık
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.apps_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              localizations.translate('appName'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        
                        // Sağ taraftaki butonlar
                        Row(
                          children: [
                            // Sıralama butonu
                            _buildSortButton(localizations),
                            
                            // Silme butonu
                            if (selectedApps.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: uninstallApps,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Seçili uygulama sayısı
                  if (selectedApps.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations.translate('selectedApps', [selectedApps.length.toString()]),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Arama alanı
                  _buildSearchField(localizations),
                  
                  // Uygulama listesi
                  Expanded(
                    child: _isLoading
                      ? _buildLoadingIndicator()
                      : filteredApps.isEmpty
                        ? _buildEmptyState(localizations)
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  itemCount: filteredApps.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.2),
                                    indent: 70,
                                    endIndent: 20,
                                  ),
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
                            ),
                          ),
                  ),
                  
                  // Banner reklam
                  const BannerAdWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Üst kısımdaki dalgalı şekil için CustomPainter
class CurvePainter extends CustomPainter {
  final Color color;
  
  CurvePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    var path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.9, size.width * 0.5, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.9)
      ..lineTo(size.width, 0)
      ..close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}