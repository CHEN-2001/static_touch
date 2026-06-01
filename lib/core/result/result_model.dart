class ResultEntity<T> {
  final bool status;
  final String message;
  final T? data;
  final int? code;

  ResultEntity({required this.status, required this.message, this.data, this.code});

  factory ResultEntity.error(String msg, {int? code}) {
    return ResultEntity(status: false, message: msg, data: null, code: code);
  }
}
