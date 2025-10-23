class ApplicationFilter {
  String? loadingRegion;
  String? loadingDistrict;
  String? unloadingRegion;
  String? unloadingDistrict;
  String? crop;
  double? minPrice;
  double? maxPrice;
  double? minDistance;
  double? maxDistance;
  DateFilter dateFilter;
  bool suitableForDumpTrucks;
  bool charterCarrier;

  ApplicationFilter({
    this.loadingRegion,
    this.loadingDistrict,
    this.unloadingRegion,
    this.unloadingDistrict,
    this.crop,
    this.minPrice,
    this.maxPrice,
    this.minDistance,
    this.maxDistance,
    this.dateFilter = DateFilter.any,
    this.suitableForDumpTrucks = false,
    this.charterCarrier = false,
  });

  ApplicationFilter copyWith({
    String? loadingRegion,
    String? loadingDistrict,
    String? unloadingRegion,
    String? unloadingDistrict,
    String? crop,
    double? minPrice,
    double? maxPrice,
    double? minDistance,
    double? maxDistance,
    DateFilter? dateFilter,
    bool? suitableForDumpTrucks,
    bool? charterCarrier,
  }) {
    return ApplicationFilter(
      loadingRegion: loadingRegion ?? this.loadingRegion,
      loadingDistrict: loadingDistrict ?? this.loadingDistrict,
      unloadingRegion: unloadingRegion ?? this.unloadingRegion,
      unloadingDistrict: unloadingDistrict ?? this.unloadingDistrict,
      crop: crop ?? this.crop,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      dateFilter: dateFilter ?? this.dateFilter,
      suitableForDumpTrucks: suitableForDumpTrucks ?? this.suitableForDumpTrucks,
      charterCarrier: charterCarrier ?? this.charterCarrier,
    );
  }

  bool get hasActiveFilters {
    return loadingRegion != null ||
        loadingDistrict != null ||
        unloadingRegion != null ||
        unloadingDistrict != null ||
        crop != null ||
        minPrice != null ||
        maxPrice != null ||
        minDistance != null ||
        maxDistance != null ||
        dateFilter != DateFilter.any ||
        suitableForDumpTrucks ||
        charterCarrier;
  }

  @override
  String toString() {
    return 'ApplicationFilter{loadingRegion: $loadingRegion, loadingDistrict: $loadingDistrict, unloadingRegion: $unloadingRegion,unloadingDistrict: $unloadingDistrict, crop: $crop, minPrice: $minPrice, maxPrice: $maxPrice, minDistance: $minDistance, maxDistance: $maxDistance, dateFilter: $dateFilter, suitableForDumpTrucks: $suitableForDumpTrucks, charterCarrier: $charterCarrier}';
  }
}

enum DateFilter {
  any,
  last3Days,
  last5Days,
  last7Days,
}