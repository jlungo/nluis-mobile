import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../data/local/database.dart' hide Form;
import '../../../dashboard/presentation/providers/ccro_providers.dart';

class AllocationsStep extends ConsumerWidget {
  final String? parcelId;
  final List<Allocation> allocations;
  final Function(List<Allocation>) onAllocationsChanged;

  const AllocationsStep({
    super.key,
    this.parcelId,
    required this.allocations,
    required this.onAllocationsChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final totalAllocation = allocations.fold(0.0, (sum, a) => sum + a.proposedShare);
    final isValid = totalAllocation == 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ugawaji wa Haki',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        
        if (allocations.isEmpty)
          Card(
            color: isDark ? AppColors.darkSurface : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              side: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'Hakuna wenye haki',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    'Ongeza wenye haki wa kipande hiki',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...allocations.map((allocation) => _buildAllocationCard(
            allocation,
            theme,
            isDark,
          )),
        
        const SizedBox(height: AppConstants.spacingMd),
        
        // Total allocation indicator
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: isValid
                ? (isDark ? AppColors.success.withOpacity(0.1) : AppColors.success.withOpacity(0.1))
                : (isDark ? AppColors.error.withOpacity(0.1) : AppColors.error.withOpacity(0.1)),
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
                  'Jumla ya Hisa: ${totalAllocation.toStringAsFixed(1)}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isValid ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
              if (!isValid)
                Text(
                  totalAllocation < 100 ? 'Ongeza ${(100 - totalAllocation).toStringAsFixed(1)}%' : 'Punguza ${(totalAllocation - 100).toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingMd),
        
        // Only show add button if allocation is not 100%
        if (!isValid)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: parcelId != null ? () => _showAddAllocationDialog(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
              ),
              icon: const Icon(Icons.person_add),
              label: const Text('Ongeza Mwenye Haki'),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: AppColors.success),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: AppConstants.spacingSm),
                Text(
                  'Ugawaji Umekamilika (100%)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAllocationCard(Allocation allocation, ThemeData theme, bool isDark) {
    return Card(
      color: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    allocation.partyName ?? 'Mwenye Haki',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIDA: ${allocation.nidaNumber ?? 'N/A'} • ${allocation.phoneNumber ?? 'N/A'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${allocation.proposedRightType} - ${allocation.proposedShare}%',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Edit button
            IconButton(
              onPressed: () => _showEditAllocationDialog(allocation),
              icon: const Icon(Icons.edit_outlined),
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              tooltip: 'Hariri',
            ),
            // Delete button
            IconButton(
              onPressed: () => _deleteAllocation(allocation),
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
              tooltip: 'Futa',
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Text(
                '${allocation.proposedShare.toStringAsFixed(0)}%',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAllocationDialog(Allocation allocation) {
    // TODO: Implement edit dialog
  }

  void _deleteAllocation(Allocation allocation) {
    final updated = List<Allocation>.from(allocations)
      ..removeWhere((a) => a.clientId == allocation.clientId);
    onAllocationsChanged(updated);
  }

  void _showAddAllocationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AddAllocationSheet(
        parcelId: parcelId!,
        existingAllocations: allocations,
        onAdd: (allocation) {
          final updated = List<Allocation>.from(allocations)..add(allocation);
          onAllocationsChanged(updated);
        },
      ),
    );
  }
}

class _AddAllocationSheet extends ConsumerStatefulWidget {
  final String parcelId;
  final List<Allocation> existingAllocations;
  final Function(Allocation) onAdd;

  const _AddAllocationSheet({
    required this.parcelId,
    required this.existingAllocations,
    required this.onAdd,
  });

  @override
  ConsumerState<_AddAllocationSheet> createState() => _AddAllocationSheetState();
}

class _AddAllocationSheetState extends ConsumerState<_AddAllocationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidaController = TextEditingController();
  final _shareController = TextEditingController();
  String _rightType = 'ownership';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nidaController.dispose();
    _shareController.dispose();
    super.dispose();
  }

  double get _remainingShare {
    final used = widget.existingAllocations.fold(0.0, (sum, a) => sum + a.proposedShare);
    return 100.0 - used;
  }

  Future<void> _saveAllocation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(ccroRepositoryProvider);
      final clientId = const Uuid().v4();
      final share = double.parse(_shareController.text);

      final allocationData = {
        'client_id': clientId,
        'parcel': widget.parcelId,
        'party_name': _nameController.text,
        'phone_number': _phoneController.text.isNotEmpty ? _phoneController.text : null,
        'nida_number': _nidaController.text.isNotEmpty ? _nidaController.text : null,
        'proposed_right_type': _rightType,
        'proposed_share': share,
      };

      final result = await repository.saveLocalAllocation(allocationData);

      await result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message)),
            );
          }
        },
        (_) async {
          // Fetch the saved allocation
          final allocationsResult = await repository.getLocalAllocations();
          allocationsResult.fold(
            (failure) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failure.message)),
                );
              }
            },
            (allocationsList) {
              final allocation = allocationsList.firstWhere(
                (a) => a.clientId == clientId,
              );
              widget.onAdd(allocation);
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mwenye haki ameongezwa')),
                );
              }
            },
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hitilafu: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.person_add,
                            color: isDark ? AppColors.darkPrimary : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ongeza Mwenye Haki',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Weka taarifa za mwenye haki',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    
                    // Name input
                    Text(
                      'Jina Kamili',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Weka jina kamili',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Weka jina';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    
                    // Phone input
                    Text(
                      'Namba ya Simu',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '0712345678',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    
                    // NIDA input
                    Text(
                      'Namba ya NIDA',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    TextFormField(
                      controller: _nidaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Weka NIDA',
                        prefixIcon: const Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    
                    // Right type
                  Text(
                    'Aina ya Haki',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  DropdownButtonFormField<String>(
                    value: _rightType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ownership', child: Text('Umiliki')),
                      DropdownMenuItem(value: 'usufruct', child: Text('Haki ya Matumizi')),
                      DropdownMenuItem(value: 'lease', child: Text('Kukodisha')),
                    ],
                    onChanged: (value) => setState(() => _rightType = value!),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  
                  // Share input
                  Text(
                    'Hisa (%) - Zimebakia: ${_remainingShare.toStringAsFixed(1)}%',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  TextFormField(
                    controller: _shareController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Weka asilimia',
                      suffixText: '%',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Weka hisa';
                      }
                      final share = double.tryParse(value);
                      if (share == null) {
                        return 'Weka namba halali';
                      }
                      if (share <= 0) {
                        return 'Hisa lazima iwe zaidi ya 0';
                      }
                      if (share > _remainingShare) {
                        return 'Hisa ni kubwa mno. Zimebakia $_remainingShare%';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            ),
                          ),
                          child: const Text('Ghairi'),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingMd),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveAllocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Ongeza'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
