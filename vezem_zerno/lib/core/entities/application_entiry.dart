class ApplicationEntity {
  final String date;
  final String from;
  final String to;
  final String cargo;
  final String weight;
  final String distance;
  final String customer;
  final String tariff;

  const ApplicationEntity({
    required this.customer,
    required this.date,
    required this.from,
    required this.to,
    required this.cargo,
    required this.weight,
    required this.distance,
    required this.tariff,
  });
}