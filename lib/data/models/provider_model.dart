import 'package:movi_mobile/domain/entities/provider.dart';

class ProviderModel {
  final int id;
  final String title;
  final String logoPath;

  ProviderModel({
    required this.id,
    required this.title,
    required this.logoPath,
  });

  // Convertir un ProviderModel en entité Provider
  Provider toEntity() {
    return Provider(
      id: id,
      title: title,
      logoPath: logoPath,
    );
  }

  // Créer un ProviderModel à partir d'une entité Provider
  factory ProviderModel.fromEntity(Provider provider) {
    return ProviderModel(
      id: provider.id,
      title: provider.title,
      logoPath: provider.logoPath,
    );
  }

  // Créer un ProviderModel à partir d'un JSON
  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'],
      title: json['title'],
      logoPath: json['logo_path'], 
    );
  }

  // Convertir un ProviderModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'logo_path': logoPath,
    };
  }
}
