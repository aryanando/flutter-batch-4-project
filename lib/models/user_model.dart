class User {
  final int id;
  final String name;
  final String email;
  final String? photo;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? unitId;
  final int? jenisKaryawanId;
  final DateTime? deletedAt;
  final int remainingLeave;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photo,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.unitId,
    this.jenisKaryawanId,
    this.deletedAt,
    required this.remainingLeave,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      unitId: json['unit_id'],
      jenisKaryawanId: json['jenis_karyawan_id'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      remainingLeave: json['remainingLeave'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'unit_id': unitId,
      'jenis_karyawan_id': jenisKaryawanId,
      'deleted_at': deletedAt?.toIso8601String(),
      'remainingLeave': remainingLeave,
    };
  }
}
