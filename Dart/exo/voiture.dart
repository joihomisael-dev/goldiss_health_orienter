class Voiture {
  int id;
  String nom;
  int num;
  static int n = 1;

  Voiture({required this.id, this.nom = "Mercedes", required this.num});

  int get _nom => id + num;
}
