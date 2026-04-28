class TravelPlace {
  const TravelPlace({
    required this.id,
    required this.title,
    required this.region,
    required this.country,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.sourcePhotoId,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String region;
  final String country;
  final String category;
  final String description;
  final String imageUrl;
  final String thumbnailUrl;
  final double latitude;
  final double longitude;
  final double rating;
  final int sourcePhotoId;
  final DateTime createdAt;

  factory TravelPlace.fromJson(Map<String, dynamic> json) {
    return TravelPlace(
      id: json['id'] as String,
      title: json['title'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      sourcePhotoId: json['sourcePhotoId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'region': region,
      'country': country,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'sourcePhotoId': sourcePhotoId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TravelPlace copyWith({
    String? id,
    String? title,
    String? region,
    String? country,
    String? category,
    String? description,
    String? imageUrl,
    String? thumbnailUrl,
    double? latitude,
    double? longitude,
    double? rating,
    int? sourcePhotoId,
    DateTime? createdAt,
  }) {
    return TravelPlace(
      id: id ?? this.id,
      title: title ?? this.title,
      region: region ?? this.region,
      country: country ?? this.country,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      sourcePhotoId: sourcePhotoId ?? this.sourcePhotoId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
