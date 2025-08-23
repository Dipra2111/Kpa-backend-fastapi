class WheelSpec {
  final int id;
  final String wheelCode;
  final int diameterMm;
  final String material;
  final String manufacturer;
  final String? notes;

  WheelSpec({
    required this.id,
    required this.wheelCode,
    required this.diameterMm,
    required this.material,
    required this.manufacturer,
    this.notes,
  });

  factory WheelSpec.fromJson(Map<String, dynamic> j) => WheelSpec(
        id: j['id'] as int,
        wheelCode: j['wheel_code'] as String,
        diameterMm: j['diameter_mm'] as int,
        material: j['material'] as String,
        manufacturer: j['manufacturer'] as String,
        notes: j['notes'] as String?,
      );
}
