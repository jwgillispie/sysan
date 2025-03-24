// lib/features/analytics/ui/system_creation_page.dart

import 'package:flutter/material.dart';

class SystemCreationPage extends StatefulWidget {
  const SystemCreationPage({Key? key}) : super(key: key);

  @override
  State<SystemCreationPage> createState() => _SystemCreationPageState();
}

class _SystemCreationPageState extends State<SystemCreationPage> {
  // Controllers
  final _systemNameController = TextEditingController();
  
  // State variables
  String _selectedSport = 'NBA';
  final List<String> _sports = ['NBA', 'NFL', 'MLB', 'NHL'];
  
  // Factors - based on the mockup we maintain factor ID and display name
  final List<Map<String, dynamic>> _factors = [
    {'id': 1, 'name': 'Factor 1', 'expanded': true},
    {'id': 2, 'name': 'Factor 2', 'expanded': false},
  ];

  @override
  void dispose() {
    _systemNameController.dispose();
    super.dispose();
  }

  void _addFactor() {
    setState(() {
      int newId = _factors.length + 1;
      _factors.add({'id': newId, 'name': 'Factor $newId', 'expanded': false});
    });
  }
  
  void _toggleFactorExpansion(int index) {
    setState(() {
      _factors[index]['expanded'] = !_factors[index]['expanded'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREATE SYSTEM', 
          style: TextStyle(
            color: Color(0xFF09BF30),
            fontWeight: FontWeight.bold,
            letterSpacing: 2
          )
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Color(0xFF09BF30),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // System Name Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary, 
                  width: 1
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _systemNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Name of System',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sport Selection Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary, 
                  width: 1
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: _selectedSport,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSport = value;
                      });
                    }
                  },
                  items: _sports.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text('Sport/League', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Factors List
            Expanded(
              child: ListView.builder(
                itemCount: _factors.length,
                itemBuilder: (context, index) {
                  bool isExpanded = _factors[index]['expanded'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Factor header - always visible
                        InkWell(
                          onTap: () => _toggleFactorExpansion(index),
                          child: Container(
                            color: Colors.green.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                'Factor ${_factors[index]['id']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Icon(
                                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        
                        // Expanded content - only visible if expanded
                        if (isExpanded)
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            child: const Text(
                              'Factor details would go here',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Add Factor Button
            TextButton(
              onPressed: _addFactor,
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('+ Factor'),
            ),
            
            const SizedBox(height: 16),
            
            // Create System Button
            ElevatedButton(
              onPressed: () {
                // Handle system creation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('System created successfully!'),
                    backgroundColor: Color(0xFF09BF30),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF09BF30),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Create System', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}