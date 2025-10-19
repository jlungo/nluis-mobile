import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class OfflineBanner extends StatelessWidget {
  final String message;
  final Key? bannerKey;

  const OfflineBanner({
    this.message = 'Uko offline. Data iliyohifadhiwa itaendelea kuonekana.',
    this.bannerKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: bannerKey,
      width: double.infinity,
      color: AppColors.warning.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: AppColors.warning, size: 18),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
