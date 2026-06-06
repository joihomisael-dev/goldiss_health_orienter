import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goldiss_health_orienter/screens/analysis_loading_screen.dart';
import 'package:goldiss_health_orienter/utile/formatage_text1.dart';
import 'package:goldiss_health_orienter/utile/get_all_hypotheses.dart';

enum ResultState { idle, loading, success, error }

class ResultsScreen extends StatefulWidget {
  final String selectedSex;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final List<String> selectedConditions;
  final bool hasFever;
  final String freeText;

  const ResultsScreen({
    super.key,
    required this.selectedSex,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.selectedConditions,
    required this.hasFever,
    required this.freeText,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  ResultState state = ResultState.idle;
  String? errorMessage;
  List<Map<String, dynamic>> hypotheses = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => state = ResultState.loading);

    try {
      final userPrompt = buildUserPrompt(
        selectedSex: widget.selectedSex,
        ageController: widget.ageController,
        heightController: widget.heightController,
        weightController: widget.weightController,
        selectedConditions: widget.selectedConditions,
        hasFever: widget.hasFever,
        freeText: widget.freeText,
      );

      final result = await getAllHypotheses(userPrompt);

      setState(() {
        hypotheses = List<Map<String, dynamic>>.from(result['hypotheses']);
        state = ResultState.success;
      });
    } on SocketException {
      setState(() {
        state = ResultState.error;
        errorMessage =
            "Impossible d'analyser pour le moment. Vérifiez votre connexion.";
      });
    } catch (e) {
      setState(() {
        state = ResultState.error;
        errorMessage =
            "Impossible d'analyser pour le moment. Vérifiez votre connexion.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A2332),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Orientation santé',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A2332),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (state) {
      case ResultState.loading:
        return _buildLoading();
      case ResultState.error:
        return _buildError();
      case ResultState.success:
        return _buildResults();
      default:
        return const SizedBox();
    }
  }

  Widget _buildLoading() {
    return const AnalysisLoadingScreen();
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFF59E0B)),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? "Une erreur est survenue. Veuillez réessayer.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadResults,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14A896),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vos résultats',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2332),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Voici les hypothèses basées sur vos symptômes.\nCes résultats ne remplacent pas un diagnostic médical.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ...hypotheses.map((h) {
            return Column(
              children: [
                _buildDiagnosisCard(
                  title: h['nom'] ?? 'Hypothèse inconnue',
                  severity: (h['gravite'] ?? 'modere').toString().toUpperCase(),
                  severityColor: _getSeverityColor(h['gravite'] ?? 'modere'),
                  description: h['description'] ?? '',
                  sections: [
                    DiagnosisSection(
                      icon: Icons.psychology_outlined,
                      label: 'CAUSES POSSIBLES',
                      text: h['causes_possibles'] ?? '',
                    ),
                    DiagnosisSection(
                      icon: Icons.self_improvement,
                      label: 'FACTEURS DE VIE',
                      text: h['facteurs_favorisants'] ?? '',
                    ),
                    DiagnosisSection(
                      icon: Icons.healing_outlined,
                      label: 'SYMPTÔMES',
                      text: h['symptomes_associes'] ?? '',
                    ),
                    DiagnosisSection(
                      icon: Icons.warning_amber_outlined,
                      label: 'RISQUES',
                      text: h['risques'] ?? '',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),

          const SizedBox(height: 32),

          const Text(
            'Que faire maintenant ?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2332),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14A896),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_services, size: 20),
                SizedBox(width: 12),
                Text(
                  'Consulter un professionnel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF14A896),
              side: const BorderSide(color: Color(0xFF14A896), width: 2),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_red_eye_outlined, size: 20),
                SizedBox(width: 12),
                Text(
                  'Surveiller l\'évolution',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ce bilan est fourni à titre indicatif et ne constitue pas un avis médical. En cas d\'urgence, contactez le 15.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String gravite) {
    switch (gravite.toLowerCase()) {
      case 'faible':
        return const Color(0xFF14A896); // vert
      case 'modere':
        return const Color(0xFFF59E0B); // orange
      case 'eleve':
      case 'élevé':
        return const Color(0xFFF87171); // rouge
      default:
        return const Color(0xFF14A896);
    }
  }

  Widget _buildDiagnosisCard({
    required String title,
    required String severity,
    required Color severityColor,
    required String description,
    List<DiagnosisSection>? sections,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2332),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  border: Border.all(color: severityColor, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: severityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      severity,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: severityColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          if (sections != null && sections.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...sections
                .map(
                  (section) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildInfoRow(
                      section.icon,
                      section.label,
                      section.text,
                    ),
                  ),
                )
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF14A896), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A2332),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Classe pour structurer les sections de diagnostic
class DiagnosisSection {
  final IconData icon;
  final String label;
  final String text;

  DiagnosisSection({
    required this.icon,
    required this.label,
    required this.text,
  });
}
