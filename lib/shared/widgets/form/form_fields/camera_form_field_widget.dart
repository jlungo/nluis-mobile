import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import 'form_field_label.dart';

class CameraFormFieldWidget extends StatefulWidget {
  final String label;
  final bool required;
  final String? value;
  final void Function(String?)? onChanged;
  final bool enabled;
  final bool allowGallery;

  const CameraFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.allowGallery = true,
  });

  @override
  State<CameraFormFieldWidget> createState() => _CameraFormFieldWidgetState();
}

class _CameraFormFieldWidgetState extends State<CameraFormFieldWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _showImageSourceDialog() async {
    if (!widget.enabled || widget.onChanged == null) return;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    await showDialog<void>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(
              'Chagua chanzo cha picha',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSm),
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSm,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                  title: const Text('Piga picha'),
                  subtitle: const Text('Tumia kamera kupiga picha mpya'),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    _captureImage(ImageSource.camera);
                  },
                ),
                if (widget.allowGallery)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppConstants.spacingSm),
                      decoration: BoxDecoration(
                        color: (isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSm,
                        ),
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                      ),
                    ),
                    title: const Text('Chagua kutoka picha zilizohifadhiwa'),
                    subtitle: const Text('Chagua picha iliyopo kwenye simu'),
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      _captureImage(ImageSource.gallery);
                    },
                  ),
              ],
            ),
          ),
    );
  }

  Future<void> _captureImage(ImageSource source) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null && mounted) {
        widget.onChanged?.call(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imeshindikana kupiga/kuchagua picha. Jaribu tena.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _removeImage() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasImage = widget.value != null && widget.value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label: widget.label, required: widget.required),
        const SizedBox(height: AppConstants.spacingSm),
        if (hasImage)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.radiusMd),
                  ),
                  child: Image.file(
                    File(widget.value!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color:
                            isDark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.surfaceVariant,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.enabled)
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSm),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surfaceVariant,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(AppConstants.radiusMd),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: _showImageSourceDialog,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Badilisha'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.primary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _removeImage,
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Ondoa'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isDark ? AppColors.errorDark : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
        else
          InkWell(
            onTap:
                widget.enabled && !_isProcessing
                    ? _showImageSourceDialog
                    : null,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingXl),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  if (_isProcessing)
                    const CircularProgressIndicator()
                  else
                    Icon(
                      Icons.add_a_photo,
                      size: 48,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    _isProcessing
                        ? 'Inachakata picha...'
                        : 'Bonyeza kupiga au kuchagua picha',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
