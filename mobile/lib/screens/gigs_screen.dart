import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../models/booking.dart';
import '../models/relocation_request.dart';

class GigsScreen extends StatefulWidget {
  const GigsScreen({super.key});

  @override
  State<GigsScreen> createState() => _GigsScreenState();
}

class _GigsScreenState extends State<GigsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flovi Driver'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available Gigs'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_AvailableGigsTab(), _MyBookingsTab()],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, this.onBook});

  final RelocationRequest request;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${request.origin} → ${request.destination}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.date,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  if (request.notes != null && request.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      request.notes!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onBook != null)
              FilledButton(onPressed: onBook, child: const Text('Book')),
          ],
        ),
      ),
    );
  }
}

class _AvailableGigsTab extends StatefulWidget {
  const _AvailableGigsTab();

  @override
  State<_AvailableGigsTab> createState() => _AvailableGigsTabState();
}

class _AvailableGigsTabState extends State<_AvailableGigsTab> {
  List<RelocationRequest> _requests = [];
  bool _isLoading = true;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
    _channel = supabase
        .channel('relocation_requests_gigs')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'relocation_requests',
          callback: (_) => _fetchRequests(),
        )
        .subscribe();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  Future<void> _fetchRequests() async {
    final data = await supabase
        .from('relocation_requests')
        .select()
        .eq('status', 'available')
        .order('date');

    if (!mounted) return;
    setState(() {
      _requests = data.map(RelocationRequest.fromMap).toList();
      _isLoading = false;
    });
  }

  Future<void> _book(RelocationRequest request) async {
    final driverId = supabase.auth.currentUser?.id;
    if (driverId == null) return;

    try {
      await supabase
          .from('bookings')
          .insert({'request_id': request.id, 'driver_id': driverId});
      await supabase
          .from('relocation_requests')
          .update({'status': 'booked'})
          .eq('id', request.id);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gig booked!')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking failed: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_requests.isEmpty) {
      return const Center(child: Text('No available gigs right now.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _requests.length,
      itemBuilder: (context, index) {
        final request = _requests[index];
        return _RequestCard(request: request, onBook: () => _book(request));
      },
    );
  }
}

class _MyBookingsTab extends StatefulWidget {
  const _MyBookingsTab();

  @override
  State<_MyBookingsTab> createState() => _MyBookingsTabState();
}

class _MyBookingsTabState extends State<_MyBookingsTab> {
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final driverId = supabase.auth.currentUser?.id;
    if (driverId == null) return;

    final data = await supabase
        .from('bookings')
        .select('id, request_id, relocation_requests(*)')
        .eq('driver_id', driverId)
        .order('booked_at', ascending: false);

    if (!mounted) return;
    setState(() {
      _bookings = data.map(Booking.fromMap).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bookings.isEmpty) {
      return const Center(child: Text('No bookings yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        return _RequestCard(request: _bookings[index].request);
      },
    );
  }
}
