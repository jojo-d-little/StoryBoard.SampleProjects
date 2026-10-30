# Lighting Effects Test

A dedicated map for particle effects, lighting, weather/phase bindings and visible parent/child compositions: **26 rooms, 41 orthogonal connections, 16 season/time phases**. Start a **new game in Seasonal Shelter** for each independent script.

- Editable project: [LightingEffectsTest.sbe.json](LightingEffectsTest.sbe.json).
- Primary custom-art export: [GameRuntimeJson/LightingEffectsTest.sbr.runtime.json](GameRuntimeJson/LightingEffectsTest.sbr.runtime.json).
- Packaged-default art comparison: [Variants/PackagedDefaults/GameRuntimeJson/LightingEffectsTest.sbr.runtime.json](Variants/PackagedDefaults/GameRuntimeJson/LightingEffectsTest.sbr.runtime.json).

| Run | Purpose | Guide |
| --- | --- | --- |
| [EffectsRegression.txt](CommandSequence/EffectsRegression.txt) | Frequent regression: 68 commands, 45 seconds of authored pauses; target 45–90 seconds including normal transport/polling overhead | [Regression guide](EFFECTS_REGRESSION_GUIDE.md) |
| [FullWalkThru.txt](CommandSequence/FullWalkThru.txt) | 504-command complete visual route with 69.2 minutes of authored pauses; ends at a real save checkpoint | [Manual walkthrough](MANUAL_WALKTHROUGH.md) |
| [WalkThru.txt](CommandSequence/WalkThru.txt), [PhaseMatrix.txt](CommandSequence/PhaseMatrix.txt) | Seasonal weather over fixed backdrops; all 16 season/time combinations | [Controls](TEST_CONTROLS.md) |
| [ObjectsLightsTuning.txt](CommandSequence/ObjectsLightsTuning.txt) | Moving fire/smoke/light, parts, binding lanes, shadows and render stages | [Objects/lights/tuning](BATCH_B_OBSERVATIONS.md) |
| [ScopeAtmosphereImages.txt](CommandSequence/ScopeAtmosphereImages.txt) | Scope replacement, applicability, isolated atmosphere, custom art and revisits | [Scope/atmosphere/art](BATCH_C_OBSERVATIONS.md) |
| [BurstsLifecycle.txt](CommandSequence/BurstsLifecycle.txt), [CatalogRemainder.txt](CommandSequence/CatalogRemainder.txt) | Bursts, stains, source lifecycle and remaining appearances | [Bursts/lifecycle](BATCH_D_OBSERVATIONS.md) |
| [BurstQuantities.txt](CommandSequence/BurstQuantities.txt) | Literal/bound/computed quantity, successful zero and distinct occurrences | [Burst quantities](BURST_QUANTITY_COVERAGE.md) |
| [RemovalPolicies.txt](CommandSequence/RemovalPolicies.txt) | Natural decay, timed fade and immediate removal | [Removal policies](REMOVAL_POLICY_COVERAGE.md) |
| [Inheritance.txt](CommandSequence/Inheritance.txt) | Five-category opt-in/out, independent child cues, lights and emitters | [Inheritance](INHERITANCE_COVERAGE.md) |
| [StressLab.txt](CommandSequence/StressLab.txt) | Separate sustained load, quiet/revisit cycles and observation checkpoints | [Stress Lab](STRESS_LAB_COVERAGE.md) |

See [MAP_PLAN.md](MAP_PLAN.md) for room locations and [SAVE_RESTORE_CHECKPOINT.md](SAVE_RESTORE_CHECKPOINT.md) for the genuine persistence workflow. All command files, including legacy/reference files, are intentionally retained. Some inline comments preserve construction-era context; use these current guides for status and script selection.

## Saved regression

[Lighting Effects Test__RegressionWalk__e2e6ca87baa245c48d62956d93997c18.sbe.recording.json](GameRuntimeJson/Recordings/Lighting%20Effects%20Test__RegressionWalk__e2e6ca87baa245c48d62956d93997c18.sbe.recording.json) is the saved schema-4, 68-step fresh-session effects baseline. Its initial Host baseline, observed Host data and export/configuration fingerprints support the owner playback assertions. Keep this file and its matching runtime assets when committing or packaging the sample. Regenerate the recording deliberately when behavior or its matched export changes.

Permanent automated coverage lives in the GameEngine/GameHost and Portal owner test suites. The saved effects recording is selected by the GameHost recording-playback manifest with `hostEffects` assertions. Run those owner tests for current results; command/state checks do not establish a visual or performance pass. One-time construction reports and temporary probe programs are not shipped with this sample.
