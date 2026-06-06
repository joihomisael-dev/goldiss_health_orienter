import 'Voiture.dart';

class VoiturePro extends Voiture {
  final int nbreChevaux;
  VoiturePro({
    required super.marque,
    required super.nom,
    required super.annee,
    required this.nbreChevaux,
  });

  @override
  void afficheVoiture() {
    // TODO: implement afficheVoiture
    super.afficheVoiture();
    print("Nombre de chevaux: $nbreChevaux\n");
  }
}
