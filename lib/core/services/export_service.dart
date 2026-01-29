import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/land_use/survey/domain/entities/survey_item.dart';
import '../database/app_database.dart';

class ExportService {
  final AppDatabase database;

  const ExportService(this.database);

  /// Export surveys to CSV format
  Future<String> exportToCSV({
    required List<SurveyItem> surveys,
    String? projectName,
  }) async {
    // Prepare CSV data
    final List<List<dynamic>> csvData = [
      // Headers
      [
        'Survey ID',
        'Questionnaire',
        'Project',
        'Status',
        'Upload Status',
        'Date Created',
        'Last Modified',
      ],
    ];

    // Add survey rows
    for (final survey in surveys) {
      csvData.add([
        survey.surveyId,
        survey.questionnaireName,
        projectName ?? survey.projectId,
        survey.isDraft ? 'Draft' : 'Completed',
        _getUploadStatusText(survey.uploadStatus),
        survey.savedDate.split(' ')[0],
        survey.savedDate,
      ]);
    }

    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(csvData);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'surveys_export_$timestamp.csv';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(csvString);

    return file.path;
  }

  /// Export surveys to PDF format (placeholder)
  Future<String> exportToPDF({
    required List<SurveyItem> surveys,
    String? projectName,
  }) async {
    // TODO: Implement PDF export with pdf package
    // For now, create a text file as placeholder
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'surveys_export_$timestamp.txt';
    final file = File('${directory.path}/$fileName');

    final buffer = StringBuffer();
    buffer.writeln('SURVEY EXPORT REPORT');
    buffer.writeln('Project: ${projectName ?? 'Unknown'}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Total Surveys: ${surveys.length}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (final survey in surveys) {
      buffer.writeln('Survey ID: ${survey.surveyId}');
      buffer.writeln('Questionnaire: ${survey.questionnaireName}');
      buffer.writeln('Status: ${survey.isDraft ? 'Draft' : 'Completed'}');
      buffer.writeln('Upload: ${_getUploadStatusText(survey.uploadStatus)}');
      buffer.writeln('Date: ${survey.savedDate}');
      buffer.writeln('-' * 50);
    }

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  /// Share exported file
  Future<void> shareFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: 'Survey Export');
  }

  String _getUploadStatusText(UploadStatus status) {
    switch (status) {
      case UploadStatus.idle:
        return 'Pending';
      case UploadStatus.uploading:
        return 'Uploading';
      case UploadStatus.success:
        return 'Uploaded';
      case UploadStatus.failure:
        return 'Failed';
    }
  }
}
