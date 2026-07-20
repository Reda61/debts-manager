class ClsApiResponse<T> {
  final T? data;
  final bool isSuccess;
  final String? errorMessage;

  ClsApiResponse({this.data, required this.isSuccess, this.errorMessage});
}
