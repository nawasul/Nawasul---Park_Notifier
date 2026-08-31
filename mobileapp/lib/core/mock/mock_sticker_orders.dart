enum StickerOrderStep { ordered, printed, shipped, delivered }

class StickerOrder {
  const StickerOrder({
    required this.id,
    required this.vehicleId,
    required this.quantity,
    required this.addressLine,
    required this.city,
    required this.postalCode,
    required this.orderDate,
    required this.currentStep,
    required this.totalPrice,
  });

  final String id;
  final String vehicleId;
  final int quantity;
  final String addressLine;
  final String city;
  final String postalCode;
  final DateTime orderDate;
  final StickerOrderStep currentStep;
  final double totalPrice;

  int get currentStepIndex => StickerOrderStep.values.indexOf(currentStep);
}

class MockStickerOrders {
  MockStickerOrders._();

  static const unitPrice = 15.0;

  static double totalFor(int quantity) => unitPrice * quantity;

  static final sampleOrder = StickerOrder(
    id: 'order-001',
    vehicleId: 'veh-002',
    quantity: 2,
    addressLine: '123 King Fahd Road, Apt 4',
    city: 'Riyadh',
    postalCode: '12345',
    orderDate: DateTime(2026, 8, 25),
    currentStep: StickerOrderStep.shipped,
    totalPrice: 30.0,
  );
}
