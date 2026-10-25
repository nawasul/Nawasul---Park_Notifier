import 'enums.dart';

class DeliveryStatus {
  const DeliveryStatus({required this.channel, required this.status});

  final DeliveryChannel channel;
  final DeliveryState status;
}

class AlertItem {
  const AlertItem({
    required this.id,
    required this.type,
    this.vehicleId,
    this.reason,
    required this.createdAt,
    this.readAt,
    this.ackAt,
    this.isTest = false,
    required this.deliveries,
  });

  final String id;
  final AlertType type;
  final String? vehicleId;
  final AlertReason? reason;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? ackAt;
  final bool isTest;
  final List<DeliveryStatus> deliveries;

  bool get isRead => readAt != null;

  AlertItem copyWith({
    DateTime? readAt,
    DateTime? ackAt,
    bool? isTest,
    List<DeliveryStatus>? deliveries,
  }) {
    return AlertItem(
      id: id,
      type: type,
      vehicleId: vehicleId,
      reason: reason,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
      ackAt: ackAt ?? this.ackAt,
      isTest: isTest ?? this.isTest,
      deliveries: deliveries ?? this.deliveries,
    );
  }
}

class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.attemptsLeft,
    this.retryAfterSeconds,
  });

  final String code;
  final String message;
  final int? attemptsLeft;
  final int? retryAfterSeconds;

  @override
  String toString() => 'AppException($code)';
}

class VerifyResult {
  const VerifyResult({
    required this.accessToken,
    required this.refreshToken,
    required this.isNewUser,
  });

  final String accessToken;
  final String refreshToken;
  final bool isNewUser;
}

class SendOtpResult {
  const SendOtpResult({required this.delivered});

  final bool delivered;
}
