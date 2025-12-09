import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/form/form_fields/text_form_field_widget.dart';
import '../../../../../shared/widgets/form/form_fields/select_form_field_widget.dart';
import '../../../../../shared/models/questionnaire.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../data/local/database.dart' as db;
import '../../../dashboard/presentation/providers/ccro_providers.dart';

class ApplicantFormStep extends ConsumerStatefulWidget {
  final int zoneId;
  final int localityId;
  final String? applicationId;
  final db.Party? applicant;
  final Function(db.Party, String) onApplicantCreated;

  const ApplicantFormStep({
    super.key,
    required this.zoneId,
    required this.localityId,
    this.applicationId,
    this.applicant,
    required this.onApplicantCreated,
  });

  @override
  ConsumerState<ApplicantFormStep> createState() => _ApplicantFormStepState();
}

class _ApplicantFormStepState extends ConsumerState<ApplicantFormStep> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nidaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String _gender = 'M';
  bool _isLoading = false;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    if (widget.applicant != null) {
      _firstNameController.text = widget.applicant!.firstName ?? '';
      _middleNameController.text = widget.applicant!.middleName ?? '';
      _lastNameController.text = widget.applicant!.lastName ?? '';
      _nidaController.text = widget.applicant!.nidaNumber ?? '';
      _phoneController.text = widget.applicant!.phone ?? '';
      _emailController.text = widget.applicant!.email ?? '';
      _gender = widget.applicant!.gender ?? 'M';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _nidaController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.applicant != null && !_showForm) {
      return _buildApplicantSummary(theme, isDark);
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Taarifa za Mwombaji',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextFormFieldWidget(
              label: 'Jina la Kwanza',
              required: true,
              controller: _firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jina la kwanza linahitajika';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextFormFieldWidget(
              label: 'Jina la Kati',
              controller: _middleNameController,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextFormFieldWidget(
              label: 'Jina la Mwisho',
              required: true,
              controller: _lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jina la mwisho linahitajika';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextFormFieldWidget(
              label: 'Namba ya NIDA',
              required: true,
              controller: _nidaController,
              keyboardType: TextInputType.number,
              placeholder: '20 digits',
              maxLength: 20,
              showCounter: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIDA inahitajika';
                }
                // if (value.length != 20) {
                //   return 'NIDA lazima iwe na tarakimu 20';
                // }
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return 'NIDA lazima iwe na nambari tu';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMd),

            SelectFormFieldWidget(
              label: 'Jinsia',
              required: true,
              value: _gender,
              options: const [
                SelectOption(value: 'M', textLabel: 'Mwanamume', position: 0),
                SelectOption(value: 'F', textLabel: 'Mwanamke', position: 1),
              ],
              onChanged: (value) {
                setState(() => _gender = value ?? 'M');
              },
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextFormFieldWidget(
              label: 'Namba ya Simu',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              placeholder: '0712345678',
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextFormFieldWidget(
              label: 'Barua Pepe',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppConstants.spacingLg),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveApplicant,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text('Hifadhi Mwombaji'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantSummary(ThemeData theme, bool isDark) {
    return Card(
      color: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: InkWell(
        onTap: _editApplicant,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.applicant!.firstName} ${widget.applicant!.lastName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.applicant!.nidaNumber != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'NIDA: ${widget.applicant!.nidaNumber}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (widget.applicant!.phone != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Simu: ${widget.applicant!.phone}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.check_circle, color: AppColors.success),
            ],
          ),
        ),
      ),
    );
  }

  void _editApplicant() {
    setState(() => _showForm = true);
  }

  Future<void> _saveApplicant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final clientId = const Uuid().v4();

      final repository = ref.read(ccroRepositoryProvider);
      final result = await repository.saveLocalParty({
        'client_id': clientId,
        'party_type': 'individual',
        'first_name': _firstNameController.text,
        'middle_name':
            _middleNameController.text.isEmpty
                ? null
                : _middleNameController.text,
        'last_name': _lastNameController.text,
        'nida_number': _nidaController.text,
        'phone_number':
            _phoneController.text.isEmpty ? null : _phoneController.text,
        'email': _emailController.text.isEmpty ? null : _emailController.text,
        'gender': _gender,
      });

      await result.fold(
        (failure) {
          if (mounted) {
            SnackBarUtils.showError(context, failure.message);
          }
        },
        (_) async {
          // Fetch the saved party
          final parties = await repository.getLocalParties();
          await parties.fold(
            (failure) {
              if (mounted) {
                SnackBarUtils.showError(context, failure.message);
              }
            },
            (partyList) async {
              final party = partyList.firstWhere((p) => p.clientId == clientId);
              
              // Create or update draft application
              final appId = widget.applicationId ?? const Uuid().v4();
              final applicationData = {
                'client_id': appId,
                'zone_snapshot': widget.zoneId,
                'locality': widget.localityId,
                'applicant': party.clientId,
                'status': 'draft',
                'current_step': 0,
              };

              final appResult = await repository.saveLocalApplication(applicationData);
              
              await appResult.fold(
                (failure) {
                  if (mounted) {
                    SnackBarUtils.showError(context, failure.message);
                  }
                },
                (_) {
                  widget.onApplicantCreated(party, appId);
                  if (mounted) {
                    setState(() => _showForm = false);
                    SnackBarUtils.showSuccess(context, 'Mwombaji amehifadhiwa');
                  }
                },
              );
            },
          );
        },
      );
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
