// Screen 3: General Information (LIGHT THEME)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldiss_health_orienter/screens/symptoms_screen.dart';
import 'package:goldiss_health_orienter/utile/formatage_text1.dart';

class GeneralInfoScreen extends StatefulWidget {
  const GeneralInfoScreen({Key? key}) : super(key: key);

  @override
  State<GeneralInfoScreen> createState() => _GeneralInfoScreenState();
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen> {
  String selectedSex = 'Homme';
  final TextEditingController ageController = TextEditingController(text: '35');
  final TextEditingController heightController = TextEditingController(
    text: '170',
  );
  final TextEditingController weightController = TextEditingController(
    text: '70',
  );

  List<String> selectedConditions = ['Aucun'];

  late final userPrompt = buildUserPrompt(
    selectedSex: selectedSex,
    ageController: ageController,
    heightController: heightController,
    weightController: weightController,
    selectedConditions: selectedConditions,
    hasFever: false,
    freeText: '',
  );

  // 🎨 Light colors
  static const background = Colors.white;
  static const surface = Color(0xFFF9FAFB);
  static const inputBg = Color.fromARGB(255, 233, 234, 238);

  static const primary = Color(0xFF14A896);

  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Quiter ?"),
            content: Text("Voulez-vous vraiment quitter ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Non"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },

                child: Text("Oui"),
              ),
            ],
          ),
        );
        return false;
      },

      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          foregroundColor: textPrimary,
          elevation: 0,

          title: const Text(
            'Informations générales',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Étape 1 sur 3',
                        style: TextStyle(
                          color: primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '33%',
                        style: TextStyle(color: textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.33,
                      backgroundColor: border,
                      valueColor: const AlwaysStoppedAnimation<Color>(primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: surface,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'À propos de vous',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _label('Âge'),
                      _textField(
                        controller: ageController,
                        hint: 'ex: 35',
                        icon: Icons.calendar_today,
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_label('Sexe'), _badge('OPTIONNEL')],
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: inputBg,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Row(
                          children: [
                            _buildSexOption('Homme'),
                            _buildSexOption('Femme'),
                            _buildSexOption('Autre'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Taille (cm)'),
                                _textField(
                                  controller: heightController,
                                  icon: Icons.straighten,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Poids (kg)'),
                                _textField(
                                  controller: weightController,
                                  icon: Icons.monitor_weight_outlined,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Antécédents médicaux',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sélectionnez tout ce qui s\'applique.',
                        style: TextStyle(fontSize: 14, color: textSecondary),
                      ),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildConditionChip(
                            'Aucun',
                            Icons.check_circle_outline,
                          ),
                          _buildConditionChip('Asthme', Icons.air),
                          _buildConditionChip(
                            'Diabète',
                            Icons.water_drop_outlined,
                          ),
                          _buildConditionChip(
                            'Hypertension',
                            Icons.favorite_border,
                          ),
                          _buildConditionChip('Autre', Icons.add),
                        ],
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SymptomsScreen(
                                selectedSex: selectedSex,
                                ageController: ageController,
                                heightController: heightController,
                                weightController: weightController,
                                selectedConditions: selectedConditions,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continuer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
  );

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: inputBg,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Text(
      'OPTIONNEL',
      style: TextStyle(
        fontSize: 11,
        color: textSecondary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    String? hint,
    required IconData icon,
  }) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide(color: border),
        ),
        suffixIcon: Icon(icon, color: textSecondary),
      ),
    ),
  );

  Widget _buildSexOption(String label) {
    final isSelected = selectedSex == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedSex = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? background : Colors.transparent,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? primary : textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionChip(String label, IconData icon) {
    final isSelected = selectedConditions.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'Aucun') {
            selectedConditions = ['Aucun'];
          } else {
            selectedConditions.remove('Aucun');
            isSelected
                ? selectedConditions.remove(label)
                : selectedConditions.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: isSelected ? primary : border, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : icon,
              color: isSelected ? primary : textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
