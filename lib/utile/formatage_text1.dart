import 'package:flutter/material.dart';

String buildUserPrompt({
  required String selectedSex,
  required TextEditingController ageController,
  required TextEditingController heightController,
  required TextEditingController weightController,
  required List<String> selectedConditions,
  required bool hasFever,
  required String freeText,
}) {
  int? parseInt(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    return int.tryParse(v);
  }

  final age = parseInt(ageController.text);
  final height = parseInt(heightController.text);
  final weight = parseInt(weightController.text);

  final sexText = selectedSex.isEmpty
      ? 'non précisé'
      : selectedSex.toLowerCase();

  final antecedentsText =
      selectedConditions.isEmpty || selectedConditions.contains('Aucun')
      ? 'aucun connu'
      : selectedConditions.join(', ');

  return '''
Voici les informations fournies par un utilisateur :

Âge : ${age != null ? '$age ans' : 'non précisé'}
Sexe : $sexText
Taille : ${height != null ? '${height} cm' : 'non précisée'}
Poids : ${weight != null ? '$weight kg' : 'non précisé'}
Fièvre : ${hasFever ? 'oui' : 'non'}
Antécédents médicaux : $antecedentsText

Description libre des symptômes :
"$freeText"

Tâche :
- Proposer au maximum 1 hypothèses de problèmes de santé possibles.
- Pour chaque hypothèse, fournir :
  - un nom simple et compréhensible
  - une courte description
  - les causes médicales possibles
  - les facteurs de la vie courante pouvant favoriser la situation
  - les symptômes fréquemment associés
  - les risques potentiels en cas d’absence de consultation
  - un niveau de gravité parmi : faible, modéré, élevé

Règles strictes :
- Ne pas poser de questions.
- Ne pas proposer de traitement.
- Ne pas poser de diagnostic.
- Rester prudent et nuancé.
''';
}
