## Bluetooth widget for ElKowars wacky widgets (EWW)

The widget provides a simple UI for all basic functionality needed for managing your bluetooth devices.

### Current features:
- Turn bluetooth on/off
- Scan for devices
- Manage paired, connected and discovered devices

### Requirements
- [EWW](https://github.com/elkowar/eww)
- bluetoothctl
- jq

### Installation
1. Clone this repository in your .config folder
2. If you already have a .yuck file somewhere else for your other widgets, add the following line in that file: `(include "../eww_bluetooth_widget/eww.yuck")` and in your .scss file: `@import "../eww_bluetooth_widget/eww.scss";`
3. Use `eww open bluetooth` to open the window.


