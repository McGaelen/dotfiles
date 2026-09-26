# Building Noctalia Plugins

This repository contains a plugin for the Wayland shell **Noctalia**. Follow these guidelines when creating or changing plugin code.

## Plugin layout

- A plugin is a directory containing a `plugin.toml` manifest and one or more isolated `.luau` entry scripts.
- Declare a stable `id`, plugin metadata, the lowest suitable `plugin_api`, entries, settings schemas, and any dependencies in `plugin.toml`.
- Supported entry types include bar widgets, desktop widgets, panels, services, shortcuts, and launcher providers.
- Keep entry scripts focused. Use service entries for background data collection and UI entries for rendering and interaction.

## API compatibility

- Plugin API versions are cumulative. Declare the lowest API level that provides every API the plugin uses; do not use a newer level without need.
- API `24` supports the safe argument-array form of `noctalia.runAsync()`.
- API `26` adds `noctalia.getSetting(...)`.
- API `28` adds native panel context menus.
- Consult the Noctalia plugin API documentation before using an API whose availability is uncertain.

## Runtime code

- Write plugin scripts in Luau (`.luau`).
- Use entry-specific lifecycle callbacks such as `update`, `onClick`, `onOpen`, `onIpc`, `onKey`, and `onExit` only where supported by that entry type.
- Prefer asynchronous operations for commands, I/O, and network calls so Noctalia's UI remains responsive.
- Execute external programs with `noctalia.runAsync()` using the argument-array form rather than building shell command strings.
- Isolate compositor- or system-specific command integration behind a small service or helper boundary.
- Use `noctalia.state` to share data between service and UI entries instead of duplicating collection work.

## UI

- Build panels and desktop widgets as retained declarative `ui.` trees.
- Bar widgets may use imperative setters for simple output or `barWidget.render(...)` for declarative rendering.
- Keep rendering driven by current state and settings. Do not block lifecycle callbacks while waiting for external data.
- Use declared manifest settings for configurable behavior; retrieve them through the supported settings APIs for the selected plugin API level.

## Available runtime facilities

The Noctalia runtime provides APIs for filesystem access, JSON and string utilities, HTTP, process execution, notifications, clipboard, settings, time, system statistics, network data, and shared state. Prefer these APIs over undeclared external dependencies when they meet the need.

## Development and testing

- Noctalia hot-reloads changed `.luau` files during local development.
- Install plugins under `$XDG_DATA_HOME/noctalia/plugins/` or expose them through a local `path` source.
- Test IPC handlers with commands in this form:

  ```sh
  noctalia msg plugin author/plugin:entry all action ...
  ```

- Toggle a panel for manual testing with:

  ```sh
  noctalia msg panel-toggle author/plugin:panel
  ```

- Validate manifest changes, entry lifecycle behavior, settings, asynchronous error handling, and UI behavior for missing or delayed external data.

## Publishing

- Publish from a source repository containing one plugin per subdirectory and a root `catalog.toml`.
- Submit third-party plugins to the `community-plugins` catalog according to Noctalia's publishing workflow.

## References

- Development overview: <https://docs.noctalia.dev/noctalia/plugins/development/>
- Manifest and settings: <https://docs.noctalia.dev/noctalia/plugins/development/manifest/>
- Entry scripts: <https://docs.noctalia.dev/noctalia/plugins/development/entries/>
- Declarative UI: <https://docs.noctalia.dev/noctalia/plugins/development/declarative-ui/>
- Runtime API: <https://docs.noctalia.dev/noctalia/plugins/development/runtime-api/>
- Plugin API versions: <https://docs.noctalia.dev/noctalia/plugins/development/plugin-api/>
- Workflow and publishing: <https://docs.noctalia.dev/noctalia/plugins/development/workflow/>