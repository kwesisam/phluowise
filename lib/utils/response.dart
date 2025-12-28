Map<String, dynamic> response({
  required bool status,
  required String message,
  dynamic data,
}) {
  return {
    'status': status,
    'message': message,
    'data': data,
  };
}
