import 'Voiture.dart';
import 'voiture_pro.dart';

void main() {
  Voiture voit1 = Voiture(
    marque: "Mercedes",
    nom: "Mercedes Benz",
    annee: Annee.ANNEE_2020,
  );
  Voiture voit2 = Voiture(
    marque: "BMW",
    nom: "BMW X5",
    annee: Annee.ANNEE_2021,
  );
  VoiturePro voit3 = VoiturePro(
    marque: "Audi",
    nom: "Audi A4",
    annee: Annee.ANNEE_2023,
    nbreChevaux: 900,
  );

  final VoiturePro voit1Copie = VoiturePro(
    marque: "Lamborghini",
    nom: "Lamborghini Aventador",
    annee: Annee.ANNEE_2021,
    nbreChevaux: 1300,
  );

  voit1Copie.afficheVoiture();
  //voit3.afficheVoiture();
  if (Voiture(marque: "BMW", nom: "BMW X5", annee: Annee.ANNEE_2021) ==
      Voiture(marque: "BMW", nom: "BMW X5", annee: Annee.ANNEE_2021)) {
    print("il sont egaux");
  } else {
    print("ils ne sont pas egaux");
  }
}
