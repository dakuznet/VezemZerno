import 'package:vezem_zerno/core/entities/application_entity.dart';

class ApplicationModel {
  final String? id;
  final String organization;
  final String customerId;
  final String loadingRegion;
  final String loadingLocality;
  final String unloadingRegion;
  final String unloadingLocality;
  final String distance;
  final String price;
  final String crop;
  final String tonnage;
  final String comment;
  final String loadingMethod;
  final String loadingDate;
  final String scalesCapacity;
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

  const ApplicationModel({
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

  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      organization: organization,
      customerId: customerId,
      loadingRegion: loadingRegion,
      loadingLocality: loadingLocality,
      unloadingRegion: unloadingRegion,
      unloadingLocality: unloadingLocality,
      distance: distance,
      crop: crop,
      tonnage: tonnage,
      comment: comment,
      loadingMethod: loadingMethod,
      loadingDate: loadingDate,
      scalesCapacity: scalesCapacity,
      price: price,
      downtime: downtime,
      shortage: shortage,
      paymentTerms: paymentTerms,
      dumpTrucks: dumpTrucks,
      charter: charter,
      paymentMethod: paymentMethod,
      status: status,
      delivered: delivered,
      createdAt: createdAt,
      responses: responses,
      carrier: carrier,
    );
  }

  factory ApplicationModel.fromEntity(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      organization: entity.organization,
      customerId: entity.customerId,
      loadingRegion: entity.loadingRegion,
      loadingLocality: entity.loadingLocality,
      unloadingRegion: entity.unloadingRegion,
      unloadingLocality: entity.unloadingLocality,
      distance: entity.distance,
      crop: entity.crop,
      tonnage: entity.tonnage,
      comment: entity.comment,
      loadingMethod: entity.loadingMethod,
      loadingDate: entity.loadingDate,
      scalesCapacity: entity.scalesCapacity,
      price: entity.price,
      downtime: entity.downtime,
      shortage: entity.shortage,
      paymentTerms: entity.paymentTerms,
      dumpTrucks: entity.dumpTrucks,
      charter: entity.charter,
      paymentMethod: entity.paymentMethod,
      status: entity.status,
      delivered: entity.delivered,
      createdAt: entity.createdAt,
      responses: entity.responses,
      carrier: entity.carrier,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '\$id': id,
      'organization': organization,
      'customerID': customerId,
      'loadingRegion': loadingRegion,
      'loadingLocality': loadingLocality,
      'unloadingRegion': unloadingRegion,
      'unloadingLocality': unloadingLocality,
      'distance': distance,
      'crop': crop,
      'tonnage': tonnage,
      'comment': comment,
      'loadingMethod': loadingMethod,
      'loadingDate': loadingDate,
      'scalesCapacity': scalesCapacity,
      'price': price,
      'downtime': downtime,
      'shortage': shortage,
      'paymentTerms': paymentTerms,
      'dumpTrucks': dumpTrucks,
      'charter': charter,
      'paymentMethod': paymentMethod,
      'status': status,
      'delivered': delivered,
      if (responses != null) 'responses': responses,
      if (carrier != null) 'carrierID': carrier,
      if (createdAt != null) '\$createdAt': createdAt!.toIso8601String(),
    };
  }

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['\$id'],
      organization: json['organization'] ?? '',
      customerId: json['customerID'] ?? '',
      loadingRegion: json['loadingRegion'] ?? '',
      loadingLocality: json['loadingLocality'] ?? '',
      unloadingRegion: json['unloadingRegion'] ?? '',
      unloadingLocality: json['unloadingLocality'] ?? '',
      distance: json['distance'] ?? '',
      crop: json['crop'] ?? '',
      tonnage: json['tonnage'] ?? '',
      comment: json['comment'] ?? '',
      loadingMethod: json['loadingMethod'] ?? '',
      loadingDate: json['loadingDate'] ?? '',
      scalesCapacity: json['scalesCapacity'] ?? '',
      price: json['price'] ?? '',
      downtime: json['downtime'] ?? '',
      shortage: json['shortage'] ?? '',
      paymentTerms: json['paymentTerms'] ?? '',
      dumpTrucks: json['dumpTrucks'] ?? false,
      charter: json['charter'] ?? false,
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? 'active',
      delivered: json['delivered'] ?? false,
      createdAt: json['\$createdAt'] != null
          ? DateTime.parse(json['\$createdAt'])
          : null,
      responses: json['responses'] != null
          ? List<String>.from(json['responses'])
          : null,
      carrier: json['carrierID'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode ^ organization.hashCode ^ customerId.hashCode;
}
