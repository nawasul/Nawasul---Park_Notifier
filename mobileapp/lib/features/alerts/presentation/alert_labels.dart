import '../../../core/models/alert_item.dart';
import '../../../core/models/enums.dart';
import '../../../l10n/app_localizations.dart';

String alertTitle(AppLocalizations l10n, AlertItem alert) {
  if (alert.isTest) return l10n.alertTestTitle;
  return switch (alert.type) {
    AlertType.orderUpdate => l10n.alertOrderUpdate,
    AlertType.stickerExpiry => l10n.alertExpiry,
    AlertType.carAlert => switch (alert.reason) {
        AlertReason.lightsOn => l10n.alertLights,
        AlertReason.doorOpen => l10n.alertDoor,
        AlertReason.flatTire => l10n.alertTire,
        AlertReason.otherUrgent => l10n.alertOther,
        AlertReason.blocking || null => l10n.alertBlocking,
      },
  };
}

String alertTimeLabel(AppLocalizations l10n, DateTime created, DateTime now) {
  final hours = now.difference(created).inHours;
  if (hours < 24) return l10n.alertHoursAgo(hours < 1 ? 1 : hours);
  final days = now.difference(created).inDays;
  return l10n.alertDaysAgo(days < 1 ? 1 : days);
}

String alertDayLabel(
  AppLocalizations l10n,
  DateTime day,
  DateTime now,
  String formattedDate,
) {
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == today) return l10n.alertsToday;
  if (day == yesterday) return l10n.alertsYesterday;
  return formattedDate;
}

String alertChannelLabel(AppLocalizations l10n, DeliveryChannel channel) {
  return switch (channel) {
    DeliveryChannel.push => l10n.alertChannelPush,
    DeliveryChannel.whatsapp => l10n.alertChannelWhatsapp,
  };
}

String alertDeliveryLabel(AppLocalizations l10n, DeliveryState status) {
  return switch (status) {
    DeliveryState.sent => l10n.alertStatusSent,
    DeliveryState.delivered => l10n.alertStatusDelivered,
    DeliveryState.read => l10n.alertStatusRead,
    DeliveryState.failed => l10n.alertStatusFailed,
  };
}
