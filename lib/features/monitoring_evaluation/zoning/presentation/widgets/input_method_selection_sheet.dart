import 'package:flutter/material.dart';
import '../../../../../shared/features/spatial/presentation/widgets/input_method_selection_sheet.dart'
    as shared;
import '../../domain/entities/zoning_feature.dart';

// Re-export for convenience
export '../../../../../shared/features/spatial/presentation/widgets/input_method_selection_sheet.dart'
    show InputMethod;

/// Zoning-specific wrapper for InputMethodSelectionSheet
class InputMethodSelectionSheet extends StatelessWidget {
  final ZoningFeatureType featureType;
  final Function(shared.InputMethod) onMethodSelected;

  const InputMethodSelectionSheet({
    super.key,
    required this.featureType,
    required this.onMethodSelected,
  });

  String _getFeatureTypeName() {
    switch (featureType) {
      case ZoningFeatureType.point:
        return 'Point';
      case ZoningFeatureType.lineString:
        return 'Line';
      case ZoningFeatureType.polygon:
        return 'Polygon';
    }
  }

  IconData _getFeatureTypeIcon() {
    switch (featureType) {
      case ZoningFeatureType.point:
        return Icons.place;
      case ZoningFeatureType.lineString:
        return Icons.timeline;
      case ZoningFeatureType.polygon:
        return Icons.crop_free;
    }
  }

  @override
  Widget build(BuildContext context) {
    return shared.InputMethodSelectionSheet(
      featureTypeName: _getFeatureTypeName(),
      featureTypeIcon: _getFeatureTypeIcon(),
      onMethodSelected: onMethodSelected,
    );
  }
}
