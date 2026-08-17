# Pet companion Rive assets

Drop a species' `.riv` file here as `{specie}.riv` (lowercase — `dog.riv`, `cat.riv`, `wolf.riv`,
`fox.riv`, `bear.riv`, `lion.riv`), matching `PetSpecieEnum`/`PetAssets.imageFor`'s existing
naming convention.

The full design and technical contract each file must satisfy — character structure, the
`Companion` state machine, its three inputs (`state`, `reducedMotion`, `interacting`) and their
exact meaning — is specified in the Rive brief, not here.

## Wiring (once a real file exists)

1. Add this directory to `pubspec.yaml`'s `flutter: assets:` list. It's deliberately **not**
   declared yet — `flutter pub get` fails hard if a declared asset directory doesn't contain the
   files it's expected to, so declaring it before any `.riv` exists would break the build for
   everyone.
2. Nothing else. `PetRiveCompanion` (`lib/features/pet/presentation/companion/rive/`) already
   tries to load `assets/rive/pet/{specie}.riv` for whichever species the current player's pet is,
   and falls back to the existing `PetMascotWidget` rendering (Lottie/PNG) whenever that file is
   missing, fails to parse, or doesn't expose a `Companion` state machine — which is what happens
   for every species today, since none of these files exist yet.
