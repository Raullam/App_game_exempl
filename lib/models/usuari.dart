class Usuari {
  final int id;
  final String nom;
  final String correu;
  final String contrasenya;
  final int edat;
  final String nacionalitat;
  final String codiPostal;
  final String imatgePerfil;

  Usuari({
    required this.id,
    required this.nom,
    required this.correu,
    required this.contrasenya,
    required this.edat,
    required this.nacionalitat,
    required this.codiPostal,
    required this.imatgePerfil,
  });

  // Mètode per convertir de JSON a objecte
  factory Usuari.fromJson(Map<String, dynamic> json) {
    return Usuari(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      correu: json['correu'] ?? '',
      contrasenya: json['contrasenya'] ?? '',
      edat: json['edat'] ?? 0,
      nacionalitat: json['nacionalitat'] ?? '',
      codiPostal: json['codiPostal'] ?? '',
      imatgePerfil: json['imatgePerfil'] ?? '',
    );
  }

  // Mètode per convertir d'objecte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'correu': correu,
      'contrasenya': contrasenya,
      'edad': edat,
      'nacionalitat': nacionalitat,
      'codi_postal': codiPostal,
      'imatge_perfil': imatgePerfil,
    };
  }
}
