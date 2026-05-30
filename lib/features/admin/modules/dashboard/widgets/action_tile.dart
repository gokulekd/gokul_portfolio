import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminActionTile extends StatefulWidget {
  const AdminActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.accentColor,
    required this.onTap,
    this.showPlus = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color accentColor;
  final VoidCallback onTap;
  final bool showPlus;

  @override
  State<AdminActionTile> createState() => _AdminActionTileState();
}

class _AdminActionTileState extends State<AdminActionTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.accentColor.withValues(alpha: 0.10)
                : const Color(0xFF15171A),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _hovered
                  ? widget.accentColor.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.06),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? widget.accentColor.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.14),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(widget.icon, color: widget.accentColor, size: 26),
                  ),
                  const Spacer(),
                  if (widget.showPlus)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.black, size: 22),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: GoogleFonts.manrope(
                  color: Colors.white60,
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Open',
                    style: GoogleFonts.manrope(
                      color: widget.accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.accentColor,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
