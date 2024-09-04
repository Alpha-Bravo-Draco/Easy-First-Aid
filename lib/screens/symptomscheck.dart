import 'package:flutter/material.dart';
import 'dart:convert'; // For jsonDecode
import 'package:flutter/services.dart';

class Symptomscheck extends StatefulWidget {
  const Symptomscheck({super.key});

  @override
  State<Symptomscheck> createState() => _SymptomscheckState();
}

class _SymptomscheckState extends State<Symptomscheck> {
  final TextEditingController searchController = TextEditingController();
  List<String> symptoms = [];
  List<String> selectedSymptoms = [];
  List<String> filteredSymptoms = [];
  Map<String, List<String>> diseaseSymptoms = {};
  List<String> availableSymptoms = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSymptomsData();
  }

  Future<void> _loadSymptomsData() async {
    final data = await rootBundle.loadString('assets/dataset.json');
    final List<dynamic> jsonData = jsonDecode(data);

    Set<String> allSymptoms = {};
    Map<String, List<String>> diseaseSymptomsMap = {};

    for (var disease in jsonData) {
      final Map<String, dynamic> diseaseMap = disease as Map<String, dynamic>;
      String diseaseName = diseaseMap['Disease'] as String;
      List<String> symptomsList = [];

      for (var key in diseaseMap.keys) {
        if (key.startsWith('Symptom_') &&
            diseaseMap[key].toString().trim().isNotEmpty) {
          symptomsList.add(diseaseMap[key].toString().trim());
          allSymptoms.add(diseaseMap[key].toString().trim());
        }
      }

      if (symptomsList.isNotEmpty) {
        diseaseSymptomsMap[diseaseName] = symptomsList;
      }
    }

    setState(() {
      availableSymptoms = allSymptoms.toList();
      filteredSymptoms = availableSymptoms;
      diseaseSymptoms = diseaseSymptomsMap;
    });
  }

  void _filterSymptoms(String query) {
    setState(() {
      searchQuery = query;
      final lowerCaseQuery = query.toLowerCase();
      filteredSymptoms = availableSymptoms.where((symptom) {
        return symptom.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  void _addSymptom(String symptom) {
    if (!selectedSymptoms.contains(symptom)) {
      setState(() {
        selectedSymptoms.add(symptom);
        searchController.clear(); // Clear the text field after adding
        filteredSymptoms = availableSymptoms; // Reset the filtered symptoms
      });
    }
  }

  void _removeSymptom(int index) {
    setState(() {
      selectedSymptoms.removeAt(index);
    });
  }

  void _searchDiseases() {
    final results = diseaseSymptoms.entries
        .where((entry) => entry.value
            .toSet()
            .intersection(selectedSymptoms.toSet())
            .isNotEmpty)
        .map((entry) => entry.key)
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Matching Diseases'),
          content: Text(results.isNotEmpty
              ? results.join(', ')
              : 'No matching diseases found.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Container(
            height: 400,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 150, 197, 197),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        "Symptoms Checker",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 176, 36, 26),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/images/FirstAid.png',
                        fit: BoxFit
                            .contain, // Adjusts the image size while maintaining aspect ratio
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextFormField(
                          controller: searchController,
                          cursorColor: const Color.fromARGB(255, 226, 0, 0),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search for symptoms",
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  _addSymptom(searchController.text.trim()),
                              icon: const Icon(Icons.add),
                              color: const Color.fromARGB(255, 152, 14, 14),
                            ),
                          ),
                          onChanged: _filterSymptoms,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: _searchDiseases,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(selectedSymptoms.length, (index) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedSymptoms[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: Colors.red,
                                onPressed: () => _removeSymptom(index),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Symptoms',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSymptoms.length,
                      itemBuilder: (context, index) {
                        final symptom = filteredSymptoms[index];
                        return ListTile(
                          title: Text(
                            symptom,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            _addSymptom(symptom);
                            FocusScope.of(context).unfocus(); // Hide keyboard
                          },
                        );
                      },
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
