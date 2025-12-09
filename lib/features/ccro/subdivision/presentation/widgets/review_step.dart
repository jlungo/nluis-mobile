import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../data/local/database.dart';

class ReviewStep extends ConsumerWidget {
  final Party? applicant;
  final Parcel? parcel;
  final List<Allocation> allocations;
  final List<ParcelPhoto> photos;
  final double totalAllocation;
  final bool isValid;

  const ReviewStep({
    super.key,
    this.applicant,
    this.parcel,
    required this.allocations,
    required this.photos,
    required this.totalAllocation,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kagua Maelezo Yote',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          
          // Validation status
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isValid
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isValid ? AppColors.success : AppColors.error,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle : Icons.warning,
                  color: isValid ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: Text(
                    isValid
                        ? 'Maelezo yote yamekamilika'
                        : 'Tafadhali kamilisha taarifa zote',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isValid ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingMd),
          
          // Applicant Section
          _buildSection(
            theme,
            isDark,
            'Mwombaji',
            Icons.person,
            applicant != null,
            [
              if (applicant != null) ...[
                _buildInfoRow('Jina', '${applicant!.firstName} ${applicant!.lastName}', theme),
                if (applicant!.nidaNumber != null)
                  _buildInfoRow('NIDA', applicant!.nidaNumber!, theme),
                if (applicant!.phone != null)
                  _buildInfoRow('Simu', applicant!.phone!, theme),
              ] else
                _buildMissingInfo('Hakuna taarifa za mwombaji', theme, isDark),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMd),
          
          // Parcel Section
          _buildSection(
            theme,
            isDark,
            'Kipande cha Ardhi',
            Icons.landscape,
            parcel != null,
            [
              if (parcel != null) ...[
                _buildInfoRow(
                  'Eneo',
                  '${((parcel!.areaSqm ?? 0) / 10000).toStringAsFixed(2)} ha',
                  theme,
                ),
                if (parcel!.north != null)
                  _buildInfoRow('Kaskazini', parcel!.north!, theme),
                if (parcel!.south != null)
                  _buildInfoRow('Kusini', parcel!.south!, theme),
                if (parcel!.east != null)
                  _buildInfoRow('Mashariki', parcel!.east!, theme),
                if (parcel!.west != null)
                  _buildInfoRow('Magharibi', parcel!.west!, theme),
              ] else
                _buildMissingInfo('Hakuna taarifa za kipande', theme, isDark),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMd),
          
          // Allocations Section
          _buildSection(
            theme,
            isDark,
            'Ugawaji wa Haki',
            Icons.people,
            allocations.isNotEmpty && totalAllocation == 100.0,
            [
              if (allocations.isNotEmpty) ...[
                ...allocations.map((a) => _buildInfoRow(
                  'Mwenye Haki',
                  '${a.proposedShare}% (${a.proposedRightType})',
                  theme,
                )),
                const Divider(),
                _buildInfoRow(
                  'Jumla',
                  '${totalAllocation.toStringAsFixed(1)}%',
                  theme,
                  isHighlight: true,
                  highlightColor: totalAllocation == 100.0 ? AppColors.success : AppColors.error,
                ),
              ] else
                _buildMissingInfo('Hakuna ugawaji', theme, isDark),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMd),
          
          // Photos Section
          _buildSection(
            theme,
            isDark,
            'Picha',
            Icons.photo_library,
            photos.isNotEmpty,
            [
              _buildInfoRow('Jumla ya Picha', '${photos.length}', theme),
              if (photos.length < 2)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Inapendekezwa kuwa na angalau picha 2',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    bool isDark,
    String title,
    IconData icon,
    bool isComplete,
    List<Widget> children,
  ) {
    return Card(
      color: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  isComplete ? Icons.check_circle : Icons.cancel,
                  color: isComplete ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    ThemeData theme, {
    bool isHighlight = false,
    Color? highlightColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isHighlight ? FontWeight.w700 : null,
                color: highlightColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingInfo(String message, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
