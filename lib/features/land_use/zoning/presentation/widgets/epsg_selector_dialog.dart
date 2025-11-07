import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../data/services/coordinate_converter.dart';

/// Dialog for selecting coordinate system (EPSG/SRID) for manual entry
class EpsgSelectorDialog extends StatefulWidget {
  final int? initialSrid;

  const EpsgSelectorDialog({super.key, this.initialSrid});

  @override
  State<EpsgSelectorDialog> createState() => _EpsgSelectorDialogState();
}

class _EpsgSelectorDialogState extends State<EpsgSelectorDialog> {
  late int _selectedSrid;
  final List<SridInfo> _supportedSrids =
      CoordinateConverter.getSupportedSrids();

  @override
  void initState() {
    super.initState();
    _selectedSrid = widget.initialSrid ?? 4326; // Default to WGS84
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.public,
                  color:
                      isDark
                          ? AppConstants.darkPrimary
                          : AppConstants.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: Text(
                    'Chagua Mfumo wa Kuratibu',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isDark
                              ? AppConstants.darkTextPrimary
                              : AppConstants.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  color:
                      isDark
                          ? AppConstants.darkTextSecondary
                          : AppConstants.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Choose the coordinate system for your measurements',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isDark
                        ? AppConstants.darkTextSecondary
                        : AppConstants.textSecondary,
              ),
            ),
            const Divider(height: AppConstants.spacingLg * 2),

            // SRID Options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _supportedSrids.length,
                itemBuilder: (context, index) {
                  final sridInfo = _supportedSrids[index];
                  final isSelected = _selectedSrid == sridInfo.srid;

                  return Container(
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSm,
                      ),
                      border: Border.all(
                        color:
                            isSelected
                                ? (isDark
                                    ? AppConstants.darkPrimary
                                    : AppConstants.primaryColor)
                                : (isDark
                                    ? AppConstants.darkBorder
                                    : AppConstants.borderColor),
                        width: isSelected ? 2 : 1,
                      ),
                      color:
                          isSelected
                              ? (isDark
                                      ? AppConstants.darkPrimary
                                      : AppConstants.primaryColor)
                                  .withValues(alpha: 0.1)
                              : null,
                    ),
                    child: RadioListTile<int>(
                      value: sridInfo.srid,
                      groupValue: _selectedSrid,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedSrid = value);
                        }
                      },
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              sridInfo.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                color:
                                    isDark
                                        ? AppConstants.darkTextPrimary
                                        : AppConstants.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingSm,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppConstants.darkPrimary
                                      : AppConstants.primaryColor)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusSm,
                              ),
                            ),
                            child: Text(
                              'EPSG:${sridInfo.srid}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark
                                        ? AppConstants.darkPrimary
                                        : AppConstants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            sridInfo.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isDark
                                      ? AppConstants.darkTextSecondary
                                      : AppConstants.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                sridInfo.isMetric
                                    ? Icons.straighten
                                    : Icons.language,
                                size: 16,
                                color:
                                    isDark
                                        ? AppConstants.darkTextSecondary
                                        : AppConstants.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                sridInfo.coordinateFormat,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color:
                                      isDark
                                          ? AppConstants.darkTextSecondary
                                          : AppConstants.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      activeColor:
                          isDark
                              ? AppConstants.darkPrimary
                              : AppConstants.primaryColor,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppConstants.spacingLg),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Ghairi',
                    style: TextStyle(
                      color:
                          isDark
                              ? AppConstants.darkTextSecondary
                              : AppConstants.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(_selectedSrid),
                  icon: const Icon(Icons.check),
                  label: const Text('Chagua'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDark
                            ? AppConstants.darkPrimary
                            : AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLg,
                      vertical: AppConstants.spacingSm,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
