import 'dart:io';

class Voiture {
  final String marque;
  final String nom;
  final Annee annee;

  Voiture({required this.marque, required this.nom, required this.annee});

  void afficheVoiture() {
    print("\nMarque: $marque");
    print("nom: $nom");
    print("annee: $annee\n");
  }

  copywith({required String marque}) {}
}

enum Annee { ANNEE_2020, ANNEE_2021, ANNEE_2022, ANNEE_2023 }
