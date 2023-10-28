class TaskDeserializationResult<T> {
  final T? data;
  final bool dataComplete;
  final Exception? exception;

  TaskDeserializationResult(
      {this.data, this.dataComplete = true, this.exception});

  bool get partialOrMissingData => dataComplete != true;
}
