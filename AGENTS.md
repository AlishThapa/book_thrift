# Development Guidelines for AI Agents

To maintain consistency, quality, and performance in the KitabSathi project, please adhere to the following rules:

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
4.  **Modularization & Folder Structure**: 
    *   Do not code everything in a single file. 
    *   Every feature/page directory must follow this structure:
        *   `bloc/`: Contains Bloc and its related files (Events, States).
        *   `models/`: Contains data models.
        *   `repo/`: Contains repository classes for API integration.
        *   `widgets/`: Contains `StatelessWidget` or `StatefulWidget` components.
        *   `feature_name.dart`: The main page/entry point for the feature.
5.  **Animations**: Use animations only where they add value to the UX. Keep them subtle and purposeful.
6.  **State Management**: Strictly **never use `setState`** for business logic or cross-component state. Use `Bloc` or `Cubit` even for smaller interactions if they affect the state of the feature. Local UI state (like tab indices or local field controllers) can use stateful widgets but prefer Bloc where possible.
7.  **Typography**: Use `FontSizes` constants for all font size definitions.
8.  **Dimensions**: Use `HeightConstants` and `WidthConstants` from `lib/constants/size_constants.dart` for providing height and width. If a needed value is missing, add it to the constants file first.
9.  **Modern UI/UX**: The app UI should feel modern, "alive," and user-friendly. Avoid dull or old-fashioned designs. Use shadows, gradients, and rounded corners (via tokens) appropriately.
10. **Consistency**: Maintain a consistent theme and feel across all pages.
11. **Dependency Injection & Blocs**: Dependency injection for Blocs should be properly managed. Global Blocs (those used across multiple features) must be provided in `main.dart` or the root shell. Avoid re-creating Bloc instances inside page builders if they need to maintain state across navigation. Use `getIt` for repository/service injection into Blocs.
12. **Navigation**: Use `auto_route` for all navigation purposes. Never use the default `Navigator` or `MaterialPageRoute` manually.
13. **Unused Imports**: Never use unused imports. Remove them to keep the code clean and maintainable.
14. **Unused Variables**: Remove unused variables to keep the code clean and maintainable.
15. **Pull to Refresh**: Always implement `RefreshIndicator` for pages that fetch data from a backend/repository to allow users to manually refresh content. Use `AlwaysScrollableScrollPhysics` on the scroll view to ensure it works even with little content.
16. **Card Distinguishability**: To ensure cards are distinguishable from the background (especially when colors are similar), use a conditional border:
    `border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.withValues(alpha: 0.3) : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1))`

17. **API Handling & Loading States**:
    *   **CRITICAL**: Always show a loading indicator (e.g., `CircularProgressIndicator` or a shimmer effect) while an API call is in progress.
    *   Every feature that interacts with an API must properly manage and UI-reflect three states:
        *   **Loading**: The request is pending.
        *   **Success**: The request completed successfully (with data or confirmation).
        *   **Error**: The request failed (show a user-friendly error message or snackbar).
    *   Use Bloc states (e.g., `Status.loading`, `Status.success`, `Status.failure`) to drive these UI changes.
