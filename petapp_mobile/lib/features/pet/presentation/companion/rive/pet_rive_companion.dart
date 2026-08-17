import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'package:petrimonium/features/pet/domain/enums/pet_animation_state.dart';
import 'package:petrimonium/features/pet/presentation/mascot/controllers/mascot_controller.dart';
import 'package:petrimonium/features/pet/presentation/mascot/widgets/pet_mascot_widget.dart';

/// The state machine name every species' `.riv` must use — see the Rive
/// brief's delivery spec. A mismatch here fails silently on the Rive side,
/// so it lives in exactly one place.
const String _kCompanionStateMachine = 'Companion';

/// Drop-in replacement for [PetMascotWidget] that renders the pet companion
/// through its Rive character (`assets/rive/pet/{specie}.riv`) once one
/// exists, and falls back to [PetMascotWidget] until then.
///
/// No species has a shipped `.riv` yet — every instance renders the fallback
/// today, honestly, because nothing is bundled at that asset path yet (see
/// `assets/rive/pet/README.md`). Dropping in a real asset that matches the
/// Rive brief's contract (state machine `Companion`, inputs `state` /
/// `reducedMotion` / `interacting`) is all that's needed to switch a species
/// over — no other code in the app changes.
class PetRiveCompanion extends StatefulWidget {
  const PetRiveCompanion({
    super.key,
    required this.controller,
    this.size = 220,
    this.interactive = true,
    this.interacting = false,
  });

  final MascotController controller;
  final double size;
  final bool interactive;

  /// Whether the companion's interaction panel is currently open — mirrors
  /// the optional `interacting` state-machine input from the Rive brief.
  final bool interacting;

  @override
  State<PetRiveCompanion> createState() => _PetRiveCompanionState();
}

class _PetRiveCompanionState extends State<PetRiveCompanion> {
  // Asset paths that have already failed to load once — checked again on
  // every rebuild otherwise, since a StatefulWidget doesn't cache across
  // instances (header + interaction sheet each mount their own). Process-
  // lifetime only; there's no cache-invalidation need since app assets don't
  // change without a fresh install.
  static final Set<String> _knownMissing = {};

  RiveFile? _riveFile;
  StateMachineController? _smController;
  SMINumber? _stateInput;
  SMIBool? _reducedMotionInput;
  SMIBool? _interactingInput;

  String get _riveAssetPath {
    final specie = widget.controller.profile.specie.name;
    final normalized = specie.trim().isEmpty ? 'dog' : specie.trim().toLowerCase();
    return 'assets/rive/pet/$normalized.riv';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant PetRiveCompanion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.profile.specie != widget.controller.profile.specie) {
      _smController?.dispose();
      _smController = null;
      _riveFile = null;
      _load();
    }
  }

  Future<void> _load() async {
    final path = _riveAssetPath;
    if (_knownMissing.contains(path)) return;
    try {
      final file = await RiveFile.asset(path);
      if (mounted) setState(() => _riveFile = file);
    } catch (_) {
      // No `.riv` at this path yet (or it failed to parse) — stay on the
      // PetMascotWidget fallback. Deliberately not rethrown: a missing
      // companion asset must never be a fatal error for the screen hosting
      // it (see the accelerometer fix this session for why unawaited
      // platform failures are dangerous here).
      _knownMissing.add(path);
    }
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      _kCompanionStateMachine,
    );
    if (controller == null) {
      // The file loaded but doesn't expose the expected state machine name
      // — treat it the same as a missing asset rather than showing a static
      // first frame with no reactions.
      _knownMissing.add(_riveAssetPath);
      if (mounted) setState(() => _riveFile = null);
      return;
    }
    artboard.addController(controller);
    _smController = controller;
    _stateInput = controller.findInput<double>('state') as SMINumber?;
    _reducedMotionInput = controller.findInput<bool>('reducedMotion') as SMIBool?;
    _interactingInput = controller.findInput<bool>('interacting') as SMIBool?;
  }

  void _syncInputs(BuildContext context) {
    _stateInput?.value = widget.controller.profile.animationState.index.toDouble();
    _reducedMotionInput?.value = MediaQuery.of(context).disableAnimations;
    _interactingInput?.value = widget.interacting;
  }

  /// Mirrors [PetMascotWidget]'s own tap-to-pet reaction, so switching a
  /// species over to Rive doesn't change what tapping the companion does in
  /// contexts that still want that behavior (`interactive: true`) — today
  /// that's neither of the two real call sites, both of which pass `false`
  /// and own their own tap handling instead.
  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.controller.triggerEventAnimation(
      PetAnimationState.happy,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _smController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file = _riveFile;
    if (file == null) {
      return PetMascotWidget(
        controller: widget.controller,
        size: widget.size,
        interactive: widget.interactive,
      );
    }

    final content = ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        _syncInputs(context);
        return RiveAnimation.direct(
          file,
          stateMachines: const [_kCompanionStateMachine],
          fit: BoxFit.contain,
          onInit: _onRiveInit,
        );
      },
    );

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.interactive ? GestureDetector(onTap: _handleTap, child: content) : content,
    );
  }
}
