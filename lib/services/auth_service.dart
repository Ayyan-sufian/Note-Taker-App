import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint('Device support check failed: $e');
      return false;
    }
  }

  /// Check if biometrics are available
  Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      debugPrint('Biometrics check failed: $e');
      return false;
    }
  }

  /// Get available biometric types (fingerprint, face, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Get biometrics failed: $e');
      return [];
    }
  }

  /// Authenticate user (pin + biometrics)
  Future<bool> authenticate({String reason = 'Authenticate'}) async {
    try {
      final bool isSupported = await isDeviceSupported();
      if (!isSupported) return false;

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false, // allow PIN/password too
      );
      return didAuthenticate;
    } catch (e) {
      debugPrint('Authentication failed: $e');
      return false;
    }
  }
}
