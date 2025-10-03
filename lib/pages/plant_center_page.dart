import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WaterLevelTestScreen extends StatefulWidget {
  const WaterLevelTestScreen({super.key});

  @override
  State<WaterLevelTestScreen> createState() => _WaterLevelTestScreenState();
}

class _WaterLevelTestScreenState extends State<WaterLevelTestScreen> {
  bool _waterLevelDetected = false;
  bool _pumpStatus = false;
  bool _isLoading = true;
  bool _isPumpLoading = false;
  String _lastUpdate = 'Never';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchLatestSensorData();
    // Refresh data every 3 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _fetchLatestSensorData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLatestSensorData() async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_latest_sensor_reading')
          .single();

      if (mounted) {
        setState(() {
          _waterLevelDetected = response['waterlevel_status'] ?? false;
          _pumpStatus = response['pump_status'] ?? false;
          _isLoading = false;
          _lastUpdate = DateTime.now().toString().substring(11, 19); // HH:MM:SS
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _lastUpdate = 'Error: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _controlPump(bool turnOn) async {
    if (_isPumpLoading) return; // Prevent multiple simultaneous requests

    setState(() {
      _isPumpLoading = true;
    });

    try {
      print('🎮 Flutter: Attempting to control pump, turnOn=$turnOn');

      // Try updating the latest row
      final result = await Supabase.instance.client
          .from('pump_sensors')
          .update({
        'pump_status': turnOn,
        'waterlevel_status': _waterLevelDetected,
        'date_time': DateTime.now().toUtc().toIso8601String(),
      })
          .order('date_time', ascending: false)
          .limit(1)
          .select();

      // If no row was updated, insert the first row
      if (result.isEmpty) {
        print('⚠️ No rows updated, inserting first row instead');
        await Supabase.instance.client.from('pump_sensors').insert({
          'pump_status': turnOn,
          'waterlevel_status': _waterLevelDetected,
          'date_time': DateTime.now().toUtc().toIso8601String(),
        });
      }

      print('✅ Flutter: Pump command applied');

      setState(() {
        _pumpStatus = turnOn;
        _isPumpLoading = false;
      });

      // Refresh after a short delay
      await Future.delayed(const Duration(seconds: 1));
      _fetchLatestSensorData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  turnOn ? Icons.power : Icons.power_off,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text('Pump ${turnOn ? 'ACTIVATED' : 'DEACTIVATED'}'),
              ],
            ),
            backgroundColor: turnOn ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Flutter: Pump control failed: $e');
      setState(() {
        _isPumpLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Failed to control pump: ${e.toString()}',
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Level Test',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE9FFF4), Color(0xFFBFF3D8), Color(0xFF77D9AA)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status indicator
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isLoading
                        ? Colors.grey.withValues(alpha: 0.2)
                        : (_waterLevelDetected
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2)),
                    border: Border.all(
                      color: _isLoading
                          ? Colors.grey
                          : (_waterLevelDetected ? Colors.green : Colors.red),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    _isLoading
                        ? Icons.hourglass_empty
                        : (_waterLevelDetected
                        ? Icons.check_circle
                        : Icons.cancel),
                    size: 80,
                    color: _isLoading
                        ? Colors.grey
                        : (_waterLevelDetected ? Colors.green : Colors.red),
                  ),
                ),

                const SizedBox(height: 30),

                // Water Level Status
                Text(
                  _isLoading
                      ? 'Loading...'
                      : (_waterLevelDetected ? 'WATER DETECTED' : 'EMPTY'),
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _isLoading
                        ? Colors.grey
                        : (_waterLevelDetected ? Colors.green : Colors.red),
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 20),

                // Pump Control Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Pump Status Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _pumpStatus ? Icons.power : Icons.power_off,
                            color:
                            _pumpStatus ? Colors.green : Colors.orange,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Pump: ${_pumpStatus ? 'ACTIVE' : 'INACTIVE'}',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: _pumpStatus
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Pump Control Toggle
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _pumpStatus
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _pumpStatus ? Colors.green : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // OFF Label
                            Expanded(
                              child: GestureDetector(
                                onTap: _isPumpLoading
                                    ? null
                                    : () => _controlPump(false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  alignment: Alignment.center,
                                  child: _isPumpLoading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Colors.grey),
                                    ),
                                  )
                                      : Text(
                                    'OFF',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: !_pumpStatus
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Toggle Switch
                            GestureDetector(
                              onTap: _isPumpLoading
                                  ? null
                                  : () => _controlPump(!_pumpStatus),
                              child: AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 300),
                                width: 60,
                                height: 40,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: _pumpStatus
                                      ? Colors.green
                                      : Colors.grey,
                                  boxShadow: _pumpStatus
                                      ? [
                                    BoxShadow(
                                      color: Colors.green
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                      : null,
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: const Duration(
                                          milliseconds: 300),
                                      left: _pumpStatus ? 22 : 2,
                                      top: 2,
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          _pumpStatus
                                              ? Icons.power
                                              : Icons.power_off,
                                          color: _pumpStatus
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ON Label
                            Expanded(
                              child: GestureDetector(
                                onTap: _isPumpLoading
                                    ? null
                                    : () => _controlPump(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  alignment: Alignment.center,
                                  child: _isPumpLoading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                    ),
                                  )
                                      : Text(
                                    'ON',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: _pumpStatus
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Status Message
                      Text(
                        _isPumpLoading
                            ? 'Sending command to pump...'
                            : _pumpStatus
                            ? 'Pump is running - Water flowing!'
                            : 'Pump is stopped - Ready to activate',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: _pumpStatus
                              ? Colors.green
                              : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Last Update Info
                Text(
                  'Last Update: $_lastUpdate',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                // Manual Refresh Button
                TextButton.icon(
                  onPressed: _fetchLatestSensorData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Now'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),

                const SizedBox(height: 20),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🚀 Pump Control Instructions:',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1. Toggle the switch above to turn pump ON/OFF\n'
                            '2. Watch for "Sending command" message\n'
                            '3. ESP32 should respond within seconds\n'
                            '4. Green = Pump ACTIVE, Orange = Pump INACTIVE\n'
                            '5. Status auto-updates every 3 seconds',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '💡 ESP32 Code: Poll database every 2-5 seconds for pump_status changes and control relay accordingly',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
