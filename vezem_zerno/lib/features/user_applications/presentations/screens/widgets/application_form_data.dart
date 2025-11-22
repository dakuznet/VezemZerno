import 'package:flutter/material.dart';

class ApplicationFormData {
  final loadingRegionController = TextEditingController();
  final loadingLocalityController = TextEditingController();
  final unloadingRegionController = TextEditingController();
  final unloadingLocalityController = TextEditingController();
  final cropController = TextEditingController();
  final transportationVolumeController = TextEditingController();
  final distanceController = TextEditingController();
  final descriptionController = TextEditingController();
  final loadingDateController = TextEditingController();
  final loadingWeightCapacityController = TextEditingController();
  final shippingPriceController = TextEditingController();
  final downtimePaymentController = TextEditingController();
  final allowableShortageController = TextEditingController();
  final paymentTermsController = TextEditingController();

  String selectedCategory = 'Не указано';
  bool suitableForDumpTrucks = false;
  bool carrierWorksByCharter = false;
   String? paymentMethod = 'Наличные';

  String get crop => cropController.text;
  String get transportationVolume => transportationVolumeController.text;
  String get distance => distanceController.text;
  String get description => descriptionController.text;
  String get loadingDate => loadingDateController.text;
  String get loadingWeightCapacity => loadingWeightCapacityController.text;
  String get shippingPrice => shippingPriceController.text;
  String get downtimePayment => downtimePaymentController.text;
  String get allowableShortage => allowableShortageController.text;
  String get paymentTerms => paymentTermsController.text;
  String get loadingRegion => loadingRegionController.text;
  String get loadingLocality => loadingLocalityController.text;
  String get unloadingRegion => unloadingRegionController.text;
  String get unloadingLocality => unloadingLocalityController.text;

  void dispose() {
    loadingRegionController.dispose();
    loadingLocalityController.dispose();
    unloadingRegionController.dispose();
    unloadingLocalityController.dispose();
    cropController.dispose();
    transportationVolumeController.dispose();
    distanceController.dispose();
    descriptionController.dispose();
    loadingWeightCapacityController.dispose();
    shippingPriceController.dispose();
    downtimePaymentController.dispose();
    allowableShortageController.dispose();
    paymentTermsController.dispose();
  }
}
