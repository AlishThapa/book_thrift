# AGENTS.md — KitabSathi / BookThrift Development Guidelines

Read this file fully before making any code modifications or creating new features.

---

## 🗂️ Project & Folder Architecture

Every single feature or page directory must adhere strictly to the following modularized structure. Do not code an entire feature inside a single file.

```
lib/features/feature_name/
├── bloc/          # Bloc, Events, States (*_bloc.dart, *_event.dart, *_state.dart)
├── models/        # Typed data models with fromJson/toJson conversions
├── repo/          # Repository classes for data fetching and API integrations
├── widgets/       # Isolated, descriptive feature-specific sub-widgets
└── feature_name_page.dart  # Main feature entry point / page scaffold
```

### Dependency Injection & State Management
* **Bloc / Cubit Only:** State management is strictly controlled via `Bloc`. Never mix with Riverpod, Provider, or GetX.
* **No local `setState` for Business Logic:** Use local UI stateful widgets *only* for ephemeral visual controls (e.g., active tab indices, text controllers). Anything touching data or cross-component state belongs in a Bloc.
* **DI via GetIt:** Always use `getIt` for injecting repositories, services, and backend instances into your Blocs.
* **Global Blocs:** Blocs that span multiple features must be provided at the root shell or in `main.dart`. Do not blindly instantiate a new Bloc inside page builders if its state needs to be maintained across screens.

---

## 🎨 Theme, Colors & Design Tokens

### The Core Design Philosophy
The UI must feel highly modern, "alive," and user-friendly. Avoid dull, vintage layouts. Leverage soft shadows, rich gradients, and precise rounded corners using tokens.

### Absolute Color Rules

1. **Follow the 60:30:10 Rule:** 60% dominant canvas background/surfaces, 30% structural secondary elements, 10% vivid accents (`AppColors.accent`).

2. **CRITICAL — Ban on `.withOpacity()`:** The `.withOpacity(0.x)` modifier is forbidden. It is deprecated or behaves inconsistently across modern Flutter framework layers. Always use `.withValues(alpha: 0.x)`.
    - ✅ Correct: `AppColors.primary.withValues(alpha: 0.08)`
    - ❌ Incorrect: `AppColors.primary.withOpacity(0.08)`

3. **No Manual `isDark` Hardcoding:** Never query or evaluate brightness to manually hardcode layout blocks (e.g., `isDark ? Colors.black : Colors.white`). Always utilize `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`. The overarching `AppTheme` handles look-and-feel toggling dynamically.

4. **Card Distinguishability Rule:** To ensure elements split cleanly against similar backgrounds (especially across light/dark responsive phases), implement this conditional utility border:
   ```dart
   border: Border.all(
     color: Theme.of(context).brightness == Brightness.dark
         ? Colors.grey.withValues(alpha: 0.3)
         : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)
   )
   ```

### Spacing, Dimensions & Radius Controls

Never pass hardcoded magic layout integers to layout options. Map them directly from design tokens:

| Token | Value |
|---|---|
| `AppRadius.sm` | 10 |
| `AppRadius.md` | 14 |
| `AppRadius.lg` | 18 |
| `AppSpacing.xxs` | 6 |
| `AppSpacing.xs` | 8 |
| `AppSpacing.sm` | 12 |
| `AppSpacing.md` | 16 |
| `AppSpacing.lg` | 20 |
| `AppSpacing.xl` | 24 |

* **Sizing Constants:** Utilize explicit definitions from `lib/constants/size_constants.dart` (`HeightConstants` / `WidthConstants`). If a required layout variation is missing, append it directly to the root token library file first.
    * `HeightConstants.bookImageHeight` → `110`
    * `WidthConstants.bookImageWidth` → `85`

---

## 📐 Strict UI/UX Rules

1. **Loading States are Mandatory:** Show a concrete visual indicator (`CircularProgressIndicator` or a themed Shimmer layout skeleton) while an API transaction is moving. Never leave a screen stagnant.

2. **Explicit Three-State Pattern:** Every view querying APIs must model and layout architecture flags for:
    * `Status.loading` — Request is pending.
    * `Status.success` — Processing succeeded (render actual content or validation confirmation).
    * `Status.failure` — Graceful error rendering presenting localized user-friendly copy (no raw exception stacks).

3. **Lazy Data Fetching:** Do not execute API loads on application boot unless it is vital for the primary container frame. For tab routing or multi-shell environments, fire requests *only* when the consumer navigates onto that unique viewport.

4. **Pull to Refresh Standard:** Implement `RefreshIndicator` for lists fetching dynamic remote structures. Force `AlwaysScrollableScrollPhysics()` on the internal viewport scroll layer so manual pulls function cleanly even when data blocks are brief.

5. **Controller Lifecycle Management:** Always call `.dispose()` on layout controllers (`AnimationController`, `TextEditingController`, `ScrollController`) inside the `dispose()` stack of `StatefulWidget` frames to avoid severe memory retention leaks.

6. **Touch Target Footprint:** Keep visual touch components mapped to minimum interactive hitboxes of **48×48px**.

7. **Auto-Dismiss Keyboards:** Wrap high-input or scrollable entry forms inside an interactive listener block to drop background focus cleanly:
   ```dart
   GestureDetector(onTap: FocusScope.of(context).unfocus)
   ```

8. **Navigation Restrictions:** All routing commands must utilize `auto_route`. Never make raw manual assignments via `Navigator.push` or native `MaterialPageRoute`.

---

## 🚫 Code Guardrails — Things We Never Do

* **Never use `Colors.white` or `Colors.black` directly:** Target explicit references within `AppColors`.
* **Never print directly to the console:** Do not drop standard `print()` statements into production features; routing execution tracing goes through the systemic project Logger wrapper.
* **Never use unassigned or dead allocations:** Zero tolerance for unused imports and hanging, unread local variables. Clean up the source block completely before shipping.
* **Never break the compilation `const` boundaries:** When tailoring tree parameters, ensure the `const` keyword is cleanly distributed or dropped. If an evaluated block becomes dynamic (e.g., using variables or runtime values), strip out the higher-level constant tree call to avoid building critical compiler failures. Conversely, systematically favor `const` properties where objects remain completely static.
* **Never design standalone raw elements:** Do not write a direct `Text` element without explicitly assigning a configured token from `AppTextStyles` or matching tracking elements within `Theme.of(context).textTheme`.
* **Never write dense monolithic trees:** Keep local `build()` methods lightweight. If an extracted view or sub-component pushes past ~40 lines of layout structure, spin it out into an independent `StatelessWidget` or `StatefulWidget` file inside the target feature's subfolder. No singular `build()` method may ever exceed **80 absolute lines**.

---

## ✅ Pull Request Checklist

Before staging code updates or declaring a screen task complete, verify every rule is checked off:

- [ ] Base layer respects `Theme.of(context).colorScheme` parameters seamlessly across themes.
- [ ] All alpha/opacity mutations exclusively leverage `.withValues(alpha: 0.x)`.
- [ ] No hardcoded numbers used for structural margins, spacing, padding, or corners.
- [ ] Screen structures map directly into the isolated standard feature layout (`bloc/`, `models/`, `repo/`, `widgets/`).
- [ ] Clean lifecycle tracking implemented — all text and animation controllers are explicitly disposed.
- [ ] Data-driven screens explicitly manage Loading, Success, and Failure visual states.
- [ ] Pull-to-refresh (`RefreshIndicator`) implemented with `AlwaysScrollableScrollPhysics` on active data grids/lists.
- [ ] Touch interactives maintain standard hitboxes (>= 48×48px).
- [ ] View navigation strictly targets the `auto_route` engine.
- [ ] Code base is fully clean of dead imports, debug logs, and unused variables.
- [ ] No localized UI `build()` method passes the 80-line ceiling.