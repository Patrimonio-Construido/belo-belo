import 'package:flutter/material.dart';

import 'package:belobelo/data/credits_section_data.dart';
import 'package:belobelo/widgets/credits_section_widget.dart';

/// Ink color sampled from the reference design; used for all text and logos
/// on this screen so it reads as one cohesive institutional credits page.
const _ink = Color(0xFF002F6F);

class CreditsScreen extends StatefulWidget {
  final String backgroundImagePath;

  const CreditsScreen({
    super.key,
    this.backgroundImagePath = creditsBackgroundPath,
  });

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _entrance;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _entrance = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(widget.backgroundImagePath, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: _ink),
                  tooltip: 'Voltar',
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: AnimatedBuilder(
                      animation: _entrance,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _entrance.value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, (1 - _entrance.value) * 12),
                            child: child,
                          ),
                        );
                      },
                      child: const _CreditsContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditsContent extends StatelessWidget {
  const _CreditsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: _RealizacaoBlock()),
            const SizedBox(width: 32),
            Expanded(
              child: Padding(
                // Aligns with "Projeto Patrimônio Construído", not the
                // smaller "Realização" caption above it.
                padding: const EdgeInsets.only(top: 24),
                child: CreditsHeadingWidget(
                  section: coordenacaoSection,
                  color: _ink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Equipe de Desenvolvimento',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _ink),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CreditsRoleRowWidget(
                section: equipeDesenvolvimentoRows[0],
                color: _ink,
                labelWidth: 130,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: CreditsRoleRowWidget(
                section: equipeDesenvolvimentoRows[1],
                color: _ink,
                labelWidth: 130,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CreditsRoleRowWidget(
                section: equipeDesenvolvimentoRows[2],
                color: _ink,
                labelWidth: 130,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: CreditsRoleRowWidget(
                section: equipeDesenvolvimentoRows[3],
                color: _ink,
                labelWidth: 130,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RealizacaoBlock extends StatelessWidget {
  const _RealizacaoBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Realização', style: TextStyle(fontSize: 15, color: _ink)),
        const SizedBox(height: 6),
        const Text(
          realizacaoProjectName,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _ink),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _TintedLogo(patrimonioConstruidoLogoPath, height: 40),
            const SizedBox(width: 20),
            const _TintedLogo(ufmgLogoPath, height: 28),
            const SizedBox(width: 16),
            const _TintedLogo(pucMinasLogoPath, height: 48),
          ],
        ),
      ],
    );
  }
}

/// Recolors a white-on-transparent logo asset to [_ink] so it reads clearly
/// against the light background, without needing a re-exported asset.
class _TintedLogo extends StatelessWidget {
  final String assetPath;
  final double height;

  const _TintedLogo(this.assetPath, {required this.height});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(_ink, BlendMode.srcIn),
      child: Image.asset(assetPath, height: height),
    );
  }
}
