import 'package:flutter_test/flutter_test.dart';
import 'package:taxiwaydriver/core/realtime/publish_gates.dart';

double flatMeters(double lat1, double lng1, double lat2, double lng2) {
  return ((lat2 - lat1).abs() + (lng2 - lng1).abs()) * 111000;
}

void main() {
  final start = DateTime(2026, 11, 12, 10);

  group('IntervalGate', () {
    test('lets the first write through and holds back writes inside the interval', () {
      final gate = IntervalGate(const Duration(seconds: 3));

      expect(gate.due(start), isTrue);
      expect(gate.due(start.add(const Duration(seconds: 1))), isFalse);
      expect(gate.due(start.add(const Duration(milliseconds: 2900))), isFalse);
      expect(gate.due(start.add(const Duration(seconds: 3))), isTrue);
    });

    test('an important change goes through immediately', () {
      final gate = IntervalGate(const Duration(seconds: 3));
      gate.due(start);

      expect(gate.due(start.add(const Duration(milliseconds: 200)), force: true), isTrue);
      expect(gate.due(start.add(const Duration(seconds: 1))), isFalse, reason: 'the forced write restarts the interval');
    });

    test('reset lets the next write through', () {
      final gate = IntervalGate(const Duration(seconds: 3));
      gate.due(start);
      gate.reset();

      expect(gate.due(start.add(const Duration(milliseconds: 100))), isTrue);
    });

    test('limits a driver reporting every second to one write per interval', () {
      final gate = IntervalGate(const Duration(seconds: 3));
      var writes = 0;
      for (var second = 0; second < 60; second++) {
        if (gate.due(start.add(Duration(seconds: second)))) writes++;
      }

      expect(writes, 20);
    });
  });

  group('PresenceGate', () {
    PresenceGate gate() => PresenceGate(distance: flatMeters);

    test('the first report is always written', () {
      expect(gate().due(start, lat: 25.6, lng: 85.1, available: true), isTrue);
    });

    test('a stationary driver is not rewritten until the keep-alive runs out', () {
      final g = gate();
      g.due(start, lat: 25.6, lng: 85.1, available: true);

      expect(g.due(start.add(const Duration(seconds: 25)), lat: 25.6, lng: 85.1, available: true), isFalse);
      expect(g.due(start.add(const Duration(seconds: 44)), lat: 25.6, lng: 85.1, available: true), isFalse);
      expect(g.due(start.add(const Duration(seconds: 45)), lat: 25.6, lng: 85.1, available: true), isTrue);
    });

    test('real movement is written even inside the keep-alive window', () {
      final g = gate();
      g.due(start, lat: 25.6, lng: 85.1, available: true);

      expect(g.due(start.add(const Duration(seconds: 25)), lat: 25.6001, lng: 85.1, available: true), isFalse, reason: 'about 11 m');
      expect(g.due(start.add(const Duration(seconds: 26)), lat: 25.6003, lng: 85.1, available: true), isTrue, reason: 'about 33 m');
    });

    test('going on a trip is written at once so riders stop seeing a bookable car', () {
      final g = gate();
      g.due(start, lat: 25.6, lng: 85.1, available: true);

      expect(g.due(start.add(const Duration(seconds: 5)), lat: 25.6, lng: 85.1, available: false), isTrue);
      expect(g.due(start.add(const Duration(seconds: 30)), lat: 25.6, lng: 85.1, available: false), isFalse);
    });

    test('a stationary driver stays fresh for readers that expire after 90 seconds', () {
      final g = gate();
      var lastWrite = start;
      var oldestSeen = Duration.zero;
      g.due(start, lat: 25.6, lng: 85.1, available: true);

      for (var tick = 1; tick <= 24; tick++) {
        final now = start.add(Duration(seconds: tick * 25));
        if (g.due(now, lat: 25.6, lng: 85.1, available: true)) lastWrite = now;
        final age = now.difference(lastWrite);
        if (age > oldestSeen) oldestSeen = age;
      }

      expect(oldestSeen, lessThan(const Duration(seconds: 90)));
    });

    test('reset forces the next report through', () {
      final g = gate();
      g.due(start, lat: 25.6, lng: 85.1, available: true);
      g.reset();

      expect(g.due(start.add(const Duration(seconds: 1)), lat: 25.6, lng: 85.1, available: true), isTrue);
    });
  });
}
