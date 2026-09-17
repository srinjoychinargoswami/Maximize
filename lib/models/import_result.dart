class ImportResult {
  final bool success;
  final String? error;
  final int tasksImported;
  final int eventsImported;
  final int remindersImported;
  final int notesImported;
  final int energyEntriesImported;
  final int completionLogsImported;
  final String? message;

  ImportResult({
    required this.success,
    this.error,
    this.tasksImported = 0,
    this.eventsImported = 0,
    this.remindersImported = 0,
    this.notesImported = 0,
    this.energyEntriesImported = 0,
    this.completionLogsImported = 0,
    this.message,
  });
}
