import 'dart:io';
import 'package:goldiss_health_orienter/Services/open_router_ai_service.dart';

List<String> hypothesePrompts = [
  'Propose la première hypothèse seulement',
  'Propose la deuxième hypothèse seulement',
  'Propose la troisième hypothèse seulement',
];

Future<Map<String, dynamic>> callHypothese(
  String userPrompt,
  String systemPrompt,
) async {
  final result = await OpenRouterAiService.callOpenRoute(
    systemPrompt,
    userPrompt,
  );

  return result; // JSON strict
}

Future<Map<String, dynamic>> getAllHypotheses(String userInfo) async {
  const String systemPrompt = '''
ROLE:
Tu es un assistant d’orientation santé préliminaire.
Tu n’es PAS un médecin.
Tu ne poses PAS de diagnostic médical.
Tu ne prescris AUCUN traitement ni médicament.

OBJECTIF:
Proposer UNE hypothèse possible de problème de santé
afin d’aider l’utilisateur à décider s’il doit consulter
un professionnel de santé.

RÈGLE CRITIQUE D’UNICITÉ (OBLIGATOIRE):
- Une seule hypothèse par réponse
- Chaque hypothèse DOIT être différente des précédentes
- Basée sur une CAUSE MÉDICALE DISTINCTE
- Ne jamais reformuler une hypothèse exclue

CONTEXTE FOURNI PAR L’APPLICATION:
- Une liste d’hypothèses déjà proposées te sera fournie
- TU DOIS ABSOLUMENT EXCLURE ces hypothèses
- Toute hypothèse similaire ou reposant sur un mécanisme proche est INTERDITE

PRINCIPES OBLIGATOIRES:
- Langage simple, clair, compréhensible
- Contexte africain et camerounais
- Toujours prudent et nuancé
- Utiliser uniquement :
  "peut être lié à", "pourrait expliquer", "peut être favorisé par"
- Ne poser AUCUNE question
- Toujours rappeler que cela ne remplace PAS une consultation médicale

FORMAT DE RÉPONSE — STRICT:
- Répondre UNIQUEMENT avec un JSON valide
- Aucun texte hors du JSON
- JSON compatible jsonDecode()

SCHÉMA JSON STRICT:
{
  "hypotheses": [
    {
      "nom": "string",
      "description": "string",
      "causes_possibles": "string",
      "facteurs_favorisants": "string",
      "symptomes_associes": "string",
      "risques": "string",
      "gravite": "faible | modere | eleve"
    }
  ]
}

CONTRAINTES:
- Fournir UNE SEULE hypothèse
- Ne jamais ajouter ou supprimer de champ
- Respecter STRICTEMENT les clés
''';

  List<Map<String, dynamic>> allHypotheses = [];
  List<String> excludedHypotheses = [];

  for (int i = 0; i < hypothesePrompts.length; i++) {
    final String userPrompt =
        '''
$userInfo

DEMANDE:
${hypothesePrompts[i]}

HYPOTHESES A EXCLURE (NE JAMAIS LES PROPOSER):
${excludedHypotheses.isEmpty ? "Aucune" : excludedHypotheses.join(", ")}
''';

    final h = await callHypothese(userPrompt, systemPrompt);

    final List<dynamic> hypotheses = h['hypotheses'];
    final Map<String, dynamic> hypothesis =
        hypotheses.first as Map<String, dynamic>;

    allHypotheses.add(hypothesis);

    // 🔒 On mémorise le nom pour exclusion future
    excludedHypotheses.add(hypothesis['nom']);

    print("Hypothèse ${i + 1} reçue: ${hypothesis['nom']}");
  }

  return {"hypotheses": allHypotheses};
}
