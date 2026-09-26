#!/usr/bin/env bun
// @vicinae.schemaVersion 1
// @vicinae.title Screenshare Mode - On
// @vicinae.mode silent

const NIRI_SCREENSHARE_CONFIG = `
  input {
    mouse {
      accel-speed 0
    }
  }
`;

if (Bun.env.XDG_CURRENT_DESKTOP === "niri") {
  await Bun.$`niri msg output DP-1 scale 1.25`;
  await Bun.$`niri msg output DP-1 mode 1680x1050@59.954`;
  await Bun.$`niri msg output DP-2 off`;

  const inputKdl = Bun.file(
    `/home/gaelen/.config/niri/include/screenshare-mode.kdl`,
  );
  await Bun.write(inputKdl, NIRI_SCREENSHARE_CONFIG);
} else {
  await Bun.$`kscreen-doctor output.DP-1.scale.1.5 output.DP-1.mode.1920x1200@60`;
  await Bun.$`kscreen-doctor output.DP-2.disable`;
}
