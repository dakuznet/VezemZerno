class ApplicationEntity {
  final String? id;
  final String organization;
  final String customerId;
  final String loadingRegion;
  final String loadingLocality;
  final String unloadingRegion;
  final String unloadingLocality;
  final String distance;
  final String crop;
  final String tonnage;
  final String comment;
  final String loadingMethod;
  final String loadingDate;
  final String scalesCapacity;
  final String price;
  final String downtime;
  final String shortage;
  final String paymentTerms;
  final bool dumpTrucks;
  final bool charter;
  final String paymentMethod;
  final String status;
  final bool delivered;
  final DateTime? createdAt;
  final List<String>? responses;
  final String? carrier;

  const ApplicationEntity({
    this.id,
    required this.organization,
    required this.customerId,
    required this.loadingRegion,
    required this.loadingLocality,
    required this.unloadingRegion,
    required this.unloadingLocality,
    required this.distance,
    required this.crop,
    required this.tonnage,
    required this.comment,
    required this.loadingMethod,
    required this.loadingDate,
    required this.scalesCapacity,
    required this.price,
    required this.downtime,
    required this.shortage,
    required this.paymentTerms,
    required this.dumpTrucks,
    required this.charter,
    required this.paymentMethod,
    required this.status,
    required this.delivered,
    this.createdAt,
    this.responses,
    this.carrier,
  });

  double? get parsedPrice {
    try {
      final cleanStr = price
          .replaceAll('₽', '')
          .replaceAll('/кг', '')
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^\d.]'), '')
          .trim();
      return double.tryParse(cleanStr);
    } catch (e) {
      return null;
    }
  }

  double? get parsedDistance {
    try {
      final cleanStr = distance
          .replaceAll('км', '')
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^\d.]'), '')
          .trim();
      return double.tryParse(cleanStr);
    } catch (e) {
      return null;
    }
  }
}
