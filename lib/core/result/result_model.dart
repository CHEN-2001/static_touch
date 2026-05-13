// 返回的result风格
class ResultEntity<T> {
  final bool status;
  final String message;
  final T? data;

  ResultEntity({required this.status, required this.message, this.data});

  factory ResultEntity.error(String msg) {
    return ResultEntity(status: false, message: msg, data: null);
  }
}
