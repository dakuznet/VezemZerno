class ApplicationFilter {
  String? loadingRegion;
  //String? loadingLocality;
  String? unloadingRegion;
  //String? unloadingLocality;
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
    //this.loadingLocality,
    this.unloadingRegion,
    //this.unloadingLocality,
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
    //String? loadingLocality,
    String? unloadingRegion,
    //String? unloadingLocality,
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
      //loadingLocality: loadingLocality ?? this.loadingLocality,
      unloadingRegion: unloadingRegion ?? this.unloadingRegion,
      //unloadingLocality: unloadingLocality ?? this.unloadingLocality,
      crop: crop ?? this.crop,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      dateFilter: dateFilter ?? this.dateFilter,
      suitableForDumpTrucks:
          suitableForDumpTrucks ?? this.suitableForDumpTrucks,
      charterCarrier: charterCarrier ?? this.charterCarrier,
    );
  }

  bool get hasActiveFilters {
    return loadingRegion != null ||
        //loadingLocality != null ||
        unloadingRegion != null ||
        //unloadingLocality != null ||
        crop != null ||
        minPrice != null ||
        maxPrice != null ||
        minDistance != null ||
        maxDistance != null ||
        dateFilter != DateFilter.any ||
        suitableForDumpTrucks ||
        charterCarrier;
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (loadingRegion != null && loadingRegion!.isNotEmpty) {
      params['loadingRegion'] = loadingRegion;
    }
    // if (loadingLocality != null && loadingLocality!.isNotEmpty) {
    //   params['loadingLocality'] = loadingLocality;
    // }
    if (unloadingRegion != null && unloadingRegion!.isNotEmpty) {
      params['unloadingRegion'] = unloadingRegion;
    }
    // if (unloadingLocality != null && unloadingLocality!.isNotEmpty) {
    //   params['unloadingLocality'] = unloadingLocality;
    // }
    if (crop != null && crop!.isNotEmpty) {
      params['crop'] = crop;
    }
    if (minPrice != null) {
      params['minPrice'] = minPrice;
    }
    if (maxPrice != null) {
      params['maxPrice'] = maxPrice;
    }
    if (minDistance != null) {
      params['minDistance'] = minDistance;
    }
    if (maxDistance != null) {
      params['maxDistance'] = maxDistance;
    }
    if (dateFilter != DateFilter.any) {
      params['dateFilter'] = dateFilter.name;
    }
    if (suitableForDumpTrucks) {
      params['dumpTrucks'] = true;
    }
    if (charterCarrier) {
      params['charter'] = true;
    }

    return params;
  }
}

enum DateFilter { any, last3Days, last5Days, last7Days }
