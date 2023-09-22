class CommonState {
  final bool isLoad;
  final bool isError;
  final bool isSuccess;
  final String errText;

  CommonState(
      {required this.errText,
      required this.isError,
      required this.isLoad,
      required this.isSuccess});

  CommonState copyWith(
      {bool? isLoad, bool? isError, bool? isSuccess, String? errText}) {
    return CommonState(
        errText: errText ?? '',
        isError: isError ?? this.isError,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess);
  }
}
