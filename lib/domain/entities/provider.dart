/// Classe représentant un fournisseur de contenu, comme Netflix ou Amazon Prime.
///
/// Un objet [Provider] contient les informations principales sur un 
/// service de streaming ou une plateforme similaire.
///
/// ### Propriétés principales :
/// - [id] : Identifiant unique du fournisseur.
/// - [title] : Nom du fournisseur (ex. "Netflix", "Disney+").
/// - [logoPath] : Chemin vers le logo du fournisseur.
class Provider {
  /// Identifiant unique du fournisseur.
  final int id;

  /// Nom du fournisseur (ex. "Netflix", "Disney+").
  final String title;

  /// Chemin vers le logo du fournisseur.
  final String logoPath;

  /// Constructeur pour initialiser un objet [Provider].
  ///
  /// - [id], [title] et [logoPath] sont requis.
  Provider({
    required this.id,
    required this.title,
    required this.logoPath,
  });
}
