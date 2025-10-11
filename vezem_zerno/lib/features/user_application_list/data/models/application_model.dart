import 'package:vezem_zerno/features/user_application_list/domain/entities/application_entity.dart';

class ApplicationModel {
  final String? id;
  final String organization;
  final String customerId;
  final String loadingPlace;
  final String unloadingPlace;
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
  final DateTime? createdAt;

  const ApplicationModel({
    this.id,
    required this.organization,
    required this.customerId,
    required this.loadingPlace,
    required this.unloadingPlace,
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
    this.createdAt,
  });

  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      customerId: customerId,
      organization: organization,
      loadingPlace: loadingPlace,
      unloadingPlace: unloadingPlace,
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
      status: ApplicationStatus.fromValue(status),
      createdAt: createdAt,
    );
  }

  factory ApplicationModel.fromEntity(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      organization: entity.organization,
      customerId: entity.customerId,
      loadingPlace: entity.loadingPlace,
      unloadingPlace: entity.unloadingPlace,
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
      status: entity.status.value,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'organization': organization,
      'loading_place': loadingPlace,
      'unloading_place': unloadingPlace,
      'crop': crop,
      'tonnage': tonnage,
      'distance': distance,
      'comment': comment,
      'loading_method': loadingMethod,
      'loading_date': loadingDate,
      'scales_capacity': scalesCapacity,
      'price': price,
      'downtime': downtime,
      'shortage': shortage,
      'payment_terms': paymentTerms,
      'dump_trucks': dumpTrucks,
      'charter': charter,
      'payment_method': paymentMethod,
      'status': status,
    };
  }

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['\$id'],
      organization: json['organization'] ?? '',
      customerId: json['customer_id'] ?? '',
      crop: json['crop'] ?? '',
      loadingPlace: json['loading_place'] ?? '',
      unloadingPlace: json['unloading_place'] ?? '',
      tonnage: json['tonnage'] ?? '',
      distance: json['distance'] ?? '',
      comment: json['comment'] ?? '',
      loadingMethod: json['loading_method'] ?? '',
      loadingDate: json['loading_date'] ?? '',
      scalesCapacity: json['scales_capacity'] ?? '',
      price: json['price'] ?? '',
      downtime: json['downtime'] ?? '',
      shortage: json['shortage'] ?? '',
      paymentTerms: json['payment_terms'] ?? '',
      dumpTrucks: json['dump_trucks'] ?? false,
      charter: json['charter'] ?? false,
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? 'draft',
      createdAt: json['\$createdAt'] != null
          ? DateTime.parse(json['\$createdAt'])
          : null,
    );
  }
}
