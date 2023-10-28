class TaskServiceResult<T> {
  final T? data;
  final bool success;

  TaskServiceResult({this.data, this.success = true});
}

class NoContent {}
