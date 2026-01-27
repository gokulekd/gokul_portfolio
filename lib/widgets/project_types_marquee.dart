import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class ProjectTypesMarquee extends StatefulWidget {
  const ProjectTypesMarquee({super.key});

  @override
  State<ProjectTypesMarquee> createState() => _ProjectTypesMarqueeState();
}

class _ProjectTypesMarqueeState extends State<ProjectTypesMarquee>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  final List<String> _projectTypes = [
    'E-commerce',
    'Social Media App',
    'Blog',
    'Block Chain',
    'Ride booking app',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    if (!mounted) return;
    _animationController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(_scrollController.offset + 1);
        }
      }
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        color: const Color(0xFF2F2F2F),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: List.generate(10, (index) {
              return Row(
                children: [
                  ..._projectTypes.map((type) => [
                        _buildProjectTypeItem(type),
                        _buildSeparator(),
                      ]).expand((element) => element),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectTypeItem(String projectType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        projectType,
        style: GoogleFonts.manrope(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: const Icon(Icons.star, color: Colors.grey, size: 16),
    );
  }
}
