class RelocationRequest {
  final String id;
  final String dispatcherId;
  final String origin;
  final String destination;
  final String date;
  final String? notes;
  final String status;

  RelocationRequest({
    required this.id,
    required this.dispatcherId,
    required this.origin,
    required this.destination,
    required this.date,
    required this.notes,
    required this.status,
  });

  factory RelocationRequest.fromMap(Map<String, dynamic> map) {
    return RelocationRequest(
      id: map['id'] as String,
      dispatcherId: map['dispatcher_id'] as String,
      origin: map['origin'] as String,
      destination: map['destination'] as String,
      date: map['date'] as String,
      notes: map['notes'] as String?,
      status: map['status'] as String,
    );
  }
}
