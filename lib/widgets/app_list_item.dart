import 'package:flutter/material.dart';
import 'package:uni/models/app_model.dart';
import 'package:uni/theme/app_theme.dart';


class AppListItem extends StatelessWidget {
  final AppModel app;
  final bool isSelected;
  final VoidCallback onTap;

  AppListItem({
    required this.app,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Daha Yuvarlak Köşeler
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2), // Açık Mavi Arkaplan
                  borderRadius: BorderRadius.circular(15), // Yuvarlak Köşeler
                ),
                child: Center(
                  child: Icon(
                    Icons.apps,
                    size: 28,
                    color: AppTheme.primaryColor, // Mavi İkon
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${app.size} - Son kullanım: ${app.lastUsed}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.accentColor, // Deniz Yeşili Onay İkonu
                ),
            ],
          ),
        ),
      ),
    );
  }
}