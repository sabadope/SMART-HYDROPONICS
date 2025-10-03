import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlantBottomSheet extends StatefulWidget {
  const AddPlantBottomSheet({super.key});

  @override
  State<AddPlantBottomSheet> createState() => _AddPlantBottomSheetState();
}

class _AddPlantBottomSheetState extends State<AddPlantBottomSheet> {
  int _selectedTab = 0; // 0 for Available plants, 1 for Add plants
  int _currentStep = 1; // Track current step (1-4)

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Tab buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Available plants tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: _selectedTab == 0
                            ? const LinearGradient(
                                colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: _selectedTab == 0 ? null : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: _selectedTab == 0
                            ? null
                            : Border.all(color: const Color(0xFF4ADE80), width: 2),
                        boxShadow: _selectedTab == 0
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF4ADE80).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          'Available plants',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _selectedTab == 0 ? Colors.white : const Color(0xFF4ADE80),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Add plants tab (circular icon button)
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 1),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: _selectedTab == 1
                          ? const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: _selectedTab == 1 ? null : Colors.white,
                      shape: BoxShape.circle,
                      border: _selectedTab == 1
                          ? null
                          : Border.all(color: const Color(0xFF3B82F6), width: 2),
                      boxShadow: _selectedTab == 1
                          ? [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Icon(
                      Icons.add,
                      color: _selectedTab == 1 ? Colors.white : const Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Content based on selected tab
          Expanded(
            child: _selectedTab == 0
                ? _buildAvailablePlantsContent()
                : _buildAddPlantsContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePlantsContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.eco,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Available Plants',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse and select from available plant templates',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Available Plants - Coming Soon!'),
                    backgroundColor: Color(0xFF4ADE80),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ADE80),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Browse Plants',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Plant Selection';
      case 2:
        return 'Configuration';
      case 3:
        return 'Settings';
      case 4:
        return 'Review';
      default:
        return 'Plant Selection';
    }
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 1:
        return 'Choose the type of plant you want to add to your hydroponic system. Select from our curated collection of hydroponic-friendly plants.';
      case 2:
        return 'Configure the optimal growing conditions for your selected plant including lighting, nutrients, and environmental settings.';
      case 3:
        return 'Set up monitoring preferences and notification settings for your new plant.';
      case 4:
        return 'Review all your settings and confirm to add the plant to your hydroponic system.';
      default:
        return 'Choose the type of plant you want to add to your hydroponic system.';
    }
  }

  Widget _buildAddPlantsContent() {
    return Column(
      children: [
        // Horizontal Progress Steps Bar - Transparent background
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < _currentStep; // Steps before current are completed
              final isCurrent = stepNumber == _currentStep; // Current step
              final isUpcoming = stepNumber > _currentStep; // Steps after current are upcoming

              return Row(
                children: [
                  // Step Circle with refined styling and click functionality
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentStep = stepNumber;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isCurrent
                            ? const LinearGradient(
                                colors: [Color(0xFF4ADE80), Color(0xFF22C55E)], // Primary green - current
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : isCompleted
                                ? const LinearGradient(
                                    colors: [Color(0xFF86EFAC), Color(0xFF4ADE80)], // Secondary green - completed
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                        color: isUpcoming ? const Color(0xFFDCFCE7) : null, // Very light green for upcoming
                        border: isUpcoming
                            ? Border.all(color: const Color(0xFF4ADE80).withValues(alpha: 0.3), width: 2)
                            : null,
                        boxShadow: isCurrent || isCompleted
                            ? [
                                BoxShadow(
                                  color: (isCurrent ? const Color(0xFF4ADE80) : const Color(0xFF86EFAC)).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          stepNumber.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 16, // Reduced font size to match tab
                            fontWeight: FontWeight.w700,
                            color: isCurrent || isCompleted ? Colors.white : const Color(0xFF4ADE80).withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Connected Line (except for last step) - No margins
                  if (index < 3) ...[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.12, // Balanced connecting lines
                      height: 2,
                      decoration: BoxDecoration(
                        color: stepNumber < 4
                            ? (isCompleted ? const Color(0xFF86EFAC) : const Color(0xFF4ADE80).withValues(alpha: 0.3))
                            : const Color(0xFF4ADE80).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
        ),

        // Step Content Area - Scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Step Content Card
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4ADE80).withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.eco,
                              size: 56,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Step $_currentStep',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _getStepTitle(_currentStep),
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _getStepDescription(_currentStep),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF6B7280),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Fixed Bottom Button Area with Next/Previous
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Add margin above buttons to prevent position shift
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Previous Button - Only visible when not on step 1
                    if (_currentStep > 1) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4ADE80),
                            side: const BorderSide(color: Color(0xFF4ADE80), width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Previous',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    // Next Button - Takes full width on step 1, half width on other steps
                    Expanded(
                      flex: _currentStep == 1 ? 2 : 1, // Full width on step 1
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentStep < 4) {
                            setState(() {
                              _currentStep++;
                            });
                          } else {
                            // Final step - show completion message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Plant setup completed!'),
                                backgroundColor: Color(0xFF4ADE80),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ADE80),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF4ADE80).withValues(alpha: 0.3),
                        ),
                        child: Text(
                          _currentStep == 4 ? 'Finish' : 'Next',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
    );
  }
}