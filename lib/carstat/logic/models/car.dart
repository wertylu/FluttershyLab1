class Car {
  int id;
  int year;
  int mileage;
  String make;
  String model;
  double zero_to_sixty;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.zero_to_sixty,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'make': make,
    'model': model,
    'year': year,
    'mileage': mileage,
    'zero_to_sixty': zero_to_sixty,
  };

  static Car fromJson(Map<String, dynamic> json) => Car(
    id: json['id'] as int,
    make: json['make'] as String,
    model: json['model'] as String,
    year: json['year'] as int,
    mileage: json['mileage'] as int,
    zero_to_sixty: json['zero_to_sixty'] as double,
  );
}
