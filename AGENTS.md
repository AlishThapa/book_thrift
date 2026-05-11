# Development Guidelines for AI Agents

To maintain consistency, quality, and performance in the Book Thrift project, please adhere to the following rules:

1.  **Design Tokens**: Use `lib/constants/design_tokens.dart` for defining radius (`AppRadius`), spacing (`AppSpacing`), and text styles (`AppTextStyles`).
2.  **Colors & Opacity**: 
    *   Use only the provided `AppColors` from `lib/constants/app_colors.dart`. 
    *   Follow the **60:30:10** color rule.
    *   **CRITICAL**: Never use `.withOpacity(0.x)`. It is deprecated or behaves inconsistently in newer Flutter versions for some contexts. Always use `.withValues(alpha: 0.x)`.
    *   Example: `AppColors.primary.withValues(alpha: 0.08)`.
3.  **Theming & Consistency**:
    *   **Never** use manual `isDark` checks in the `build` method to toggle colors (e.g., `isDark ? Colors.black : Colors.white`).
    *   **Always** use `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`. The `AppTheme` is already configured to switch these automatically.
    *   Example: Use `Theme.of(context).colorScheme.surface` instead of checking `brightness`.
4.  **Modularization**: Do not code everything in a single file. Delegate UI components into separate `StatelessWidget` or `StatefulWidget` classes and keep them in a `widgets/` folder within the specific feature directory.
4.  **Animations**: Use animations only where they add value to the UX. Keep them subtle and purposeful.
5.  **State Management**: Strictly **never use `setState`** for business logic or cross-component state. Use `Bloc` or `Cubit` even for smaller interactions if they affect the state of the feature. Local UI state (like tab indices or local field controllers) can use stateful widgets but prefer Bloc where possible.
6.  **Typography**: Use `FontSizes` constants for all font size definitions.
7.  **Dimensions**: Use `HeightConstants` and `WidthConstants` from `lib/constants/size_constants.dart` for providing height and width. If a needed value is missing, add it to the constants file first.
8.  **Modern UI/UX**: The app UI should feel modern, "alive," and user-friendly. Avoid dull or old-fashioned designs. Use shadows, gradients, and rounded corners (via tokens) appropriately.
9.  **Consistency**: Maintain a consistent theme and feel across all pages.
10. **Dependency Injection & Blocs**: Dependency injection for Blocs should be properly managed. Global Blocs (those used across multiple features) must be provided in `main.dart` or the root shell. Avoid re-creating Bloc instances inside page builders if they need to maintain state across navigation. Use `getIt` for repository/service injection into Blocs.
