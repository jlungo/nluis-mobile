import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/dialog_utils.dart';

enum FileType { document, image, any }

class FileFormFieldWidget extends StatelessWidget {
  final String label;
  final bool required;
  final File? value;
  final void Function(File?)? onChanged;
  final void Function()? onPickFile;
  final void Function()? onRemove;
  final bool enabled;
  final FileType fileType;
  final List<String>? allowedExtensions;

  const FileFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    this.value,
    this.onChanged,
    this.onPickFile,
    this.onRemove,
    this.enabled = true,
    this.fileType = FileType.any,
    this.allowedExtensions,
  });

  Future<void> _pickFile(BuildContext context) async {
    if (!enabled) return;

    try {
      FilePickerResult? result;
      
      switch (fileType) {
        case FileType.document:
          result = await FilePicker.platform.pickFiles(
            type: allowedExtensions != null 
                ? file_picker.FileType.custom 
                : file_picker.FileType.any,
            allowedExtensions: allowedExtensions,
            allowMultiple: false,
          );
          break;
        case FileType.image:
          result = await FilePicker.platform.pickFiles(
            type: file_picker.FileType.image,
            allowMultiple: false,
          );
          break;
        case FileType.any:
          result = await FilePicker.platform.pickFiles(
            type: allowedExtensions != null 
                ? file_picker.FileType.custom 
                : file_picker.FileType.any,
            allowedExtensions: allowedExtensions,
            allowMultiple: false,
          );
          break;
      }

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        onChanged?.call(file);
      }
    } catch (e) {
      if (context.mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Hitilafu',
          message: 'Imeshindikana kuchagua faili. Jaribu tena.',
        );
      }
    }
  }

  void _removeFile() {
    if (enabled) {
      onChanged?.call(null);
      onRemove?.call();
    }
  }

  String _getFileIcon(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.pdf':
        return '📄';
      case '.doc':
      case '.docx':
        return '📝';
      case '.xls':
      case '.xlsx':
        return '📊';
      case '.ppt':
      case '.pptx':
        return '📋';
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.bmp':
      case '.webp':
        return '🖼️';
      case '.mp4':
      case '.avi':
      case '.mov':
        return '🎥';
      case '.mp3':
      case '.wav':
      case '.aac':
        return '🎵';
      case '.zip':
      case '.rar':
      case '.7z':
        return '🗜️';
      default:
        return '📁';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: isDark ? AppColors.errorDark : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        if (value != null) ...[
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // File icon based on extension
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.darkPrimary : AppColors.primary).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: Text(
                        _getFileIcon(value!.path),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            path.basename(value!.path),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          FutureBuilder<FileStat>(
                            future: value!.stat(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  _formatFileSize(snapshot.data!.size),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (enabled) ...[
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.visibility,
                      //     color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      //   ),
                      //   onPressed: () {
                      //
                      //   },
                      //   tooltip: 'Angalia faili',
                      // ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark ? AppColors.errorDark : AppColors.error,
                        ),
                        onPressed: _removeFile,
                        tooltip: 'Ondoa faili',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
        ],
        OutlinedButton.icon(
          onPressed: enabled ? () => _pickFile(context) : null,
          icon: Icon(
            value != null ? Icons.change_circle : Icons.upload_file,
            color: enabled 
                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                : (isDark ? AppColors.darkTextHint : AppColors.textHint),
          ),
          label: Text(
            value != null ? 'Badilisha faili' : 'Chagua faili',
            style: TextStyle(
              color: enabled 
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : (isDark ? AppColors.darkTextHint : AppColors.textHint),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: enabled 
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : (isDark ? AppColors.darkTextHint : AppColors.textHint),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
          ),
        ),
      ],
    );
  }
}
