// Screen 4: Symptoms Screen
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goldiss_health_orienter/screens/results_screen.dart';
import 'package:goldiss_health_orienter/screens/urgent_consultation_screen.dart';
import 'package:goldiss_health_orienter/utile/formatage_text1.dart';
import 'package:goldiss_health_orienter/utile/get_all_hypotheses.dart';

class SymptomsScreen extends StatefulWidget {
  final String selectedSex;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final List<String> selectedConditions;

  const SymptomsScreen({
    super.key,
    required this.selectedSex,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.selectedConditions,
  });

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  bool hasFever = false;
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _onNext() async {
    final userPrompt = buildUserPrompt(
      selectedSex: widget.selectedSex,
      ageController: widget.ageController,
      heightController: widget.heightController,
      weightController: widget.weightController,
      selectedConditions: widget.selectedConditions,
      hasFever: hasFever,
      freeText: descriptionController.text,
    );

    // Ici tu peux passer userPrompt à ta fonction IA
    try {
      final result = await getAllHypotheses(userPrompt);
      print("Length réponse brute: ${result.toString().length}");
    } on SocketException {
      print("pas de connection");
    } catch (e) {
      print("erreur");
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
          'Symptômes Ressentis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A2332),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Étape 2 sur 3',
                  style: TextStyle(
                    color: Color(0xFF14A896),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.66,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF14A896),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fièvre',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2332),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Avez-vous une température corporelle élevée ?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedAlign(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      alignment: hasFever
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        width: 80,
                                        height: 46,
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: hasFever
                                              ? const Color(0xFF14A896)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            23,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            hasFever ? 'Oui' : 'Non',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: hasFever
                                                  ? Colors.white
                                                  : const Color(0xFF6B7280),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(
                                              () => hasFever = false,
                                            ),
                                            child: Container(
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Non',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: !hasFever
                                                      ? Colors.transparent
                                                      : const Color(0xFF9CA3AF),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () =>
                                                setState(() => hasFever = true),
                                            child: Container(
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Oui',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: hasFever
                                                      ? Colors.transparent
                                                      : const Color(0xFF9CA3AF),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Décrivez ce que vous ressentez',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2332),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 8,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A2332),
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Exemple : fièvre depuis 2 jours, fatigue, maux de tête, toux légère...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultsScreen(
                            selectedSex: widget.selectedSex,
                            ageController: widget.ageController,
                            heightController: widget.heightController,
                            weightController: widget.weightController,
                            selectedConditions: widget.selectedConditions,
                            hasFever: hasFever,
                            freeText: descriptionController.text,
                          ),
                        ),
                      );
                      //_onNext();
                    },
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
                          'Analyser mon état de santé',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
