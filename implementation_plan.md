# Implementation Plan - Improve Categories Screen UI

The user wants to improve the "odd" centered title on the Categories screen. To achieve a more premium and consistent look with the rest of the app (specifically `ExploreScreen`), I will:

1.  **Refactor `CategoriesScreen`**:
    -   Replace the standard `AppBar` + `GridView` structure with a `CustomScrollView`.
    -   Implement a `SliverAppBar` similar to `ExploreScreen` but titled "Browse Categories".
    -   Use the app's dark green theme (`0xFF1B4332`) for the header background with a gradient.
    -   Add decorative background icons in the header for visual interest.
    -   Convert the existing `GridView.builder` into a `SliverGrid` within the `CustomScrollView`'s slivers array.

2.  **Verify UI**:
    -   Ensure standard padding and spacing are maintained.
    -   Ensure navigation functionality remains intact.
