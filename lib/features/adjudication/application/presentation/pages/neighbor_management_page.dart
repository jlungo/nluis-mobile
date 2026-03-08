import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for neighbors list with auto-refresh
final applicationNeighborsProvider =
    FutureProvider.family<List<ApplicationNeighbor>, int>((
      ref,
      applicationId,
    ) async {
      final repository = ref.watch(adjudicationRepositoryProvider);
      final result = await repository.getNeighbors(applicationId);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (neighbors) => neighbors,
      );
    });

class NeighborManagementPage extends ConsumerStatefulWidget {
  final int applicationId;
  final String applicationNumber;

  const NeighborManagementPage({
    super.key,
    required this.applicationId,
    required this.applicationNumber,
  });

  @override
  ConsumerState<NeighborManagementPage> createState() =>
      _NeighborManagementPageState();
}

class _NeighborManagementPageState
    extends ConsumerState<NeighborManagementPage> {
  @override
  Widget build(BuildContext context) {
    final neighborsAsync = ref.watch(
      applicationNeighborsProvider(widget.applicationId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Majirani: ${widget.applicationNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddNeighborDialog(context),
            tooltip: 'Ongeza Jirani',
          ),
        ],
      ),
      body: neighborsAsync.when(
        data: (neighbors) {
          if (neighbors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Hakuna majirani waliosajiliwa',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bofya kitufe cha "+" kuongeza jirani',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: neighbors.length,
            itemBuilder: (context, index) {
              final neighbor = neighbors[index];
              return _NeighborCard(
                neighbor: neighbor,
                onEdit: () => _showEditNeighborDialog(context, neighbor),
                onVerify: () => _showVerifyNeighborDialog(context, neighbor),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Hitilafu imetokea',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: AppColors.error),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
      ),
    );
  }

  void _showAddNeighborDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => NeighborFormDialog(
            applicationId: widget.applicationId,
            onSave: (data) async {
              Navigator.pop(context);
              await _addNeighbor(data);
            },
          ),
    );
  }

  void _showEditNeighborDialog(
    BuildContext context,
    ApplicationNeighbor neighbor,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => NeighborFormDialog(
            applicationId: widget.applicationId,
            neighbor: neighbor,
            onSave: (data) async {
              Navigator.pop(context);
              await _updateNeighbor(neighbor.id, data);
            },
          ),
    );
  }

  void _showVerifyNeighborDialog(
    BuildContext context,
    ApplicationNeighbor neighbor,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => VerifyNeighborDialog(
            neighbor: neighbor,
            onVerify: (verified, notes) async {
              Navigator.pop(context);
              await _verifyNeighbor(neighbor.id, verified, notes);
            },
          ),
    );
  }

  Future<void> _addNeighbor(Map<String, dynamic> data) async {
    try {
      final repository = ref.read(adjudicationRepositoryProvider);
      final neighborData = ApplicationNeighbor(
        id: 0, // Will be assigned by the API
        application: widget.applicationId,
        name: data['name'],
        direction: data['direction'],
        directionDisplay: '', // Will be set by the API
        neighborType: data['neighbor_type'],
        neighborTypeDisplay: '', // Will be set by the API
        fieldVerified: false,
        createdAt: DateTime.now(),
      );

      final result = await repository.addNeighbor(neighborData);
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hitilafu: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          ref.invalidate(applicationNeighborsProvider(widget.applicationId));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Jirani ameongezwa'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hitilafu: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _updateNeighbor(
    int neighborId,
    Map<String, dynamic> data,
  ) async {
    try {
      final repository = ref.read(adjudicationRepositoryProvider);
      final result = await repository.updateNeighbor(neighborId, data);

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hitilafu: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          ref.invalidate(applicationNeighborsProvider(widget.applicationId));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Jirani amerekebishwa'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hitilafu: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _verifyNeighbor(
    int neighborId,
    bool verified,
    String? notes,
  ) async {
    try {
      final repository = ref.read(adjudicationRepositoryProvider);
      final result = await repository.verifyNeighbor(
        neighborId,
        fieldVerified: verified,
        fieldNotes: notes,
      );

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hitilafu: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (_) {
          ref.invalidate(applicationNeighborsProvider(widget.applicationId));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                verified ? 'Jirani amethibitishwa' : 'Jirani amekataliwa',
              ),
              backgroundColor: verified ? AppColors.success : AppColors.warning,
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hitilafu: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class _NeighborCard extends StatelessWidget {
  final ApplicationNeighbor neighbor;
  final VoidCallback onEdit;
  final VoidCallback onVerify;

  const _NeighborCard({
    required this.neighbor,
    required this.onEdit,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    neighbor.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildVerificationBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Direction badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    neighbor.directionDisplay,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    neighbor.neighborTypeDisplay,
                    style: TextStyle(
                      color: _getTypeColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (neighbor.fieldVerified && neighbor.fieldNotes != null) ...[
              const SizedBox(height: 12),
              Text(
                'Maelezo: ${neighbor.fieldNotes}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Hariri'),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: onVerify,
                  icon: Icon(
                    neighbor.fieldVerified
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    size: 18,
                    color: neighbor.fieldVerified ? AppColors.success : null,
                  ),
                  label: Text(
                    neighbor.fieldVerified ? 'Imethibitishwa' : 'Thibitisha',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    if (neighbor.fieldVerified) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 14, color: AppColors.success),
            const SizedBox(width: 4),
            Text(
              'Imethibitishwa',
              style: TextStyle(
                color: AppColors.success,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.pending, size: 14, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            'Haitathibitishwa',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (neighbor.neighborType) {
      case 'property':
        return AppColors.primary;
      case 'road':
        return AppColors.info;
      case 'water':
        return Colors.blue;
      case 'government':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}

class NeighborFormDialog extends StatefulWidget {
  final int applicationId;
  final ApplicationNeighbor? neighbor;
  final Function(Map<String, dynamic>) onSave;

  const NeighborFormDialog({
    super.key,
    required this.applicationId,
    this.neighbor,
    required this.onSave,
  });

  @override
  State<NeighborFormDialog> createState() => _NeighborFormDialogState();
}

class _NeighborFormDialogState extends State<NeighborFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String _direction = 'north';
  String _neighborType = 'property';

  final List<Map<String, dynamic>> _directions = [
    {'value': 'north', 'label': 'Kaskazini'},
    {'value': 'east', 'label': 'Mashariki'},
    {'value': 'south', 'label': 'Kusini'},
    {'value': 'west', 'label': 'Magharibi'},
    {'value': 'northeast', 'label': 'Kaskazini-Mashariki'},
    {'value': 'southeast', 'label': 'Kusini-Mashariki'},
    {'value': 'southwest', 'label': 'Kusini-Magharibi'},
    {'value': 'northwest', 'label': 'Kaskazini-Magharibi'},
  ];

  // final List<Map<String, dynamic>> _neighborTypes = [
  //   {'value': 'property', 'label': 'Kiwanja cha Mtu'},
  //   {'value': 'road', 'label': 'Barabara'},
  //   {'value': 'other', 'label': 'Nyingine'},
  // ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.neighbor?.name ?? '');
    if (widget.neighbor != null) {
      _direction = widget.neighbor!.direction;
      _neighborType = widget.neighbor!.neighborType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.neighbor == null ? 'Ongeza Jirani' : 'Hariri Jirani'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Jina la Jirani',
                  hintText: 'Weka jina la jirani',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jina linahitajika';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Upande', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _direction,
                decoration: const InputDecoration(hintText: 'Chagua upande'),
                items:
                    _directions.map((direction) {
                      return DropdownMenuItem<String>(
                        value: direction['value'] as String,
                        child: Text(direction['label'] as String),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _direction = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Upande unahitajika';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Text(
              //   'Aina ya Jirani',
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
              // const SizedBox(height: 8),
              // DropdownButtonFormField<String>(
              //   value: _neighborType,
              //   decoration: const InputDecoration(hintText: 'Chagua aina'),
              //   items:
              //       _neighborTypes.map((type) {
              //         return DropdownMenuItem<String>(
              //           value: type['value'] as String,
              //           child: Text(type['label'] as String),
              //         );
              //       }).toList(),
              //   onChanged: (value) {
              //     if (value != null) {
              //       setState(() {
              //         _neighborType = value;
              //       });
              //     }
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Aina inahitajika';
              //     }
              //     return null;
              //   },
              // ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ghairi'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final data = {
                'name': _nameController.text,
                'direction': _direction,
                'neighbor_type': _neighborType,
                'application': widget.applicationId,
              };

              widget.onSave(data);
            }
          },
          child: Text(widget.neighbor == null ? 'Ongeza' : 'Hifadhi'),
        ),
      ],
    );
  }
}

class VerifyNeighborDialog extends StatefulWidget {
  final ApplicationNeighbor neighbor;
  final Function(bool, String?) onVerify;

  const VerifyNeighborDialog({
    super.key,
    required this.neighbor,
    required this.onVerify,
  });

  @override
  State<VerifyNeighborDialog> createState() => _VerifyNeighborDialogState();
}

class _VerifyNeighborDialogState extends State<VerifyNeighborDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  bool _isVerified = true;

  @override
  void initState() {
    super.initState();
    _isVerified = widget.neighbor.fieldVerified;
    _notesController.text = widget.neighbor.fieldNotes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thibitisha Jirani'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jirani: ${widget.neighbor.name}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Upande: ${widget.neighbor.directionDisplay}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Aina: ${widget.neighbor.neighborTypeDisplay}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Jirani Amethibitishwa?'),
              value: _isVerified,
              onChanged: (value) {
                setState(() {
                  _isVerified = value;
                });
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Maelezo (si lazima)',
                hintText: 'Andika maelezo kuhusu thibitisho...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ghairi'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onVerify(
                _isVerified,
                _notesController.text.isEmpty ? null : _notesController.text,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isVerified ? AppColors.success : Colors.orange,
          ),
          child: Text(_isVerified ? 'Thibitisha' : 'Kataa'),
        ),
      ],
    );
  }
}
