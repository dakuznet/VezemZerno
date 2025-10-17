class ApplicationEntity {
  final String? id;
  final String customerId;
  final String organization;
  final String loadingPlace;
  final String unloadingPlace;
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
  final ApplicationStatus status;
  final DateTime? createdAt;
  final DateTime? publishedAt;

  const ApplicationEntity({
    this.id,
    required this.customerId,
    required this.organization,
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
    this.status = ApplicationStatus.active,
    this.createdAt,
    this.publishedAt,
  });

  // Бизнес-методы
  bool get isActive => status == ApplicationStatus.active;
  
  // Валидация
  bool get isValid {
    return loadingPlace.isNotEmpty &&
        unloadingPlace.isNotEmpty &&
        crop.isNotEmpty &&
        tonnage.isNotEmpty &&
        price.isNotEmpty;
  }

  // Копирование с изменениями
  ApplicationEntity copyWith({
    String? id,
    String? customerId,
    String? organization,
    String? loadingPlace,
    String? unloadingPlace,
    String? distance,
    String? crop,
    String? tonnage,
    String? comment,
    String? loadingMethod,
    String? loadingDate,
    String? scalesCapacity,
    String? price,
    String? downtime,
    String? shortage,
    String? paymentTerms,
    bool? dumpTrucks,
    bool? charter,
    String? paymentMethod,
    ApplicationStatus? status,
    DateTime? createdAt,
    DateTime? publishedAt,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      organization: organization ?? this.organization,
      loadingPlace: loadingPlace ?? this.loadingPlace,
      unloadingPlace: unloadingPlace ?? this.unloadingPlace,
      distance: distance ?? this.distance,
      crop: crop ?? this.crop,
      tonnage: tonnage ?? this.tonnage,
      comment: comment ?? this.comment,
      loadingMethod: loadingMethod ?? this.loadingMethod,
      loadingDate: loadingDate ?? this.loadingDate,
      scalesCapacity: scalesCapacity ?? this.scalesCapacity,
      price: price ?? this.price,
      downtime: downtime ?? this.downtime,
      shortage: shortage ?? this.shortage,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      dumpTrucks: dumpTrucks ?? this.dumpTrucks,
      charter: charter ?? this.charter,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
    );
  }
}

enum ApplicationStatus {
  active('active', 'Активная'),
  inProgress('in_progress', 'В работе'),
  completed('completed', 'Завершена'),
  cancelled('cancelled', 'Отменена');

  final String value;
  final String displayName;

  const ApplicationStatus(this.value, this.displayName);

  static ApplicationStatus fromValue(String value) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ApplicationStatus.active,
    );
  }
}