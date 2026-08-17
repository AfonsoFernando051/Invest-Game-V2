import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';
import 'package:petrimonium/features/pet/presentation/companion/pet_companion_controller.dart';
import 'package:petrimonium/features/pet/presentation/companion/pet_message.dart';

/// Floats [PetCompanionController]'s current message above page content
/// without permanently reserving layout space — the product spec's "never
/// cover important content, always dismissible" requirement, satisfied by
/// keeping this an overlay the host screen positions in a `Stack`, not an
/// inline widget that pushes content down.
///
/// Handles its own enter/exit animation and reduced-motion (`xp_bar.dart`,
/// `cosmic_background.dart` set the precedent for reading
/// `MediaQuery.disableAnimations` directly rather than a shared helper).
class PetSpeechBubbleOverlay extends StatelessWidget {
  const PetSpeechBubbleOverlay({
    super.key,
    required this.controller,
    this.onActionSelected,
  });

  final PetCompanionController controller;

  /// Invoked with the tapped action's destination context when the message
  /// has one — the host screen owns navigation (tab switches, pushes), this
  /// widget only reports the intent.
  final ValueChanged<PetMessageAction>? onActionSelected;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final message = controller.currentMessage;
        return AnimatedSwitcher(
          duration: reducedMotion
              ? Duration.zero
              : const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.08),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: message == null
              ? const SizedBox.shrink(key: ValueKey('empty'))
              : Align(
                  key: ValueKey(message.id),
                  alignment: Alignment.topCenter,
                  child: _PetSpeechBubble(
                    message: message,
                    onDismiss: controller.dismiss,
                    onAction: () {
                      if (message.action != null) {
                        controller.dismiss();
                        onActionSelected?.call(message.action!);
                      }
                    },
                  ),
                ),
        );
      },
    );
  }
}

class _PetSpeechBubble extends StatelessWidget {
  const _PetSpeechBubble({
    required this.message,
    required this.onDismiss,
    required this.onAction,
  });

  final PetMessage message;
  final VoidCallback onDismiss;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final text = Translator.translate(message.textKey, params: message.params);

    return Semantics(
      liveRegion: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: GlassCard(
          backgroundColor: tokens.surfaceElevated.withValues(
            alpha: context.isDarkMode ? 0.85 : 0.97,
          ),
          borderColor: AppColors.neonCyan.withValues(alpha: 0.35),
          borderRadius: 18,
          borderWidth: 1,
          boxShadow: [
            BoxShadow(
              color: AppColors.neonCyan.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: tokens.textPrimary,
                          fontSize: 13.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (message.action != null) ...[
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onAction();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  Translator.translate(
                                    message.action!.labelKey,
                                  ),
                                  style: const TextStyle(
                                    color: AppColors.neonCyan,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: AppColors.neonCyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Semantics(
                  button: true,
                  label: Translator.translate(
                    AppStrings.companionDismissTooltip,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: tokens.textTertiary,
                    ),
                    tooltip: Translator.translate(
                      AppStrings.companionDismissTooltip,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: onDismiss,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
