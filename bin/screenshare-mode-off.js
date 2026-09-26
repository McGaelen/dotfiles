#!/usr/bin/env bun
// @vicinae.schemaVersion 1
// @vicinae.title Screenshare Mode - Off
// @vicinae.mode silent

if (Bun.env.XDG_CURRENT_DESKTOP === "niri") {
  await Bun.$`niri msg output DP-1 scale 1`;
  await Bun.$`niri msg output DP-1 mode 2560x1440@359.999`;
  await Bun.$`niri msg output DP-2 on`;

  const inputKdl = Bun.file(
    `/home/gaelen/.config/niri/include/screenshare-mode.kdl`,
  ).delete();
} else {
  await Bun.$`kscreen-doctor output.DP-1.scale.1 output.DP-1.mode.2560x1440@360`;
  await Bun.$`kscreen-doctor output.DP-2.enable`;
}
