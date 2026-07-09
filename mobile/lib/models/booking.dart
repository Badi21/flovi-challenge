import 'relocation_request.dart';

class Booking {
  final String id;
  final String requestId;
  final RelocationRequest request;

  Booking({required this.id, required this.requestId, required this.request});

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as String,
      requestId: map['request_id'] as String,
      request: RelocationRequest.fromMap(
        map['relocation_requests'] as Map<String, dynamic>,
      ),
    );
  }
}
