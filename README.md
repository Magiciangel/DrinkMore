# DrinkMore

![DrinkMore logo](Assets/DrinkMoreLogo.png)

DrinkMore is an open-source macOS hydration reminder app. It stays lightweight, lives in the menu bar, tracks the cups you actually use, and escalates from a notification to a full-screen reminder when a reminder goes unanswered.

## Features

- Add and edit real cups, including name, drink type, and capacity.
- Quickly log water, coffee, tea, or other drinks from the main window or menu bar.
- Track how many cups you drank today and the total liquid intake in ml.
- Customize countdown-based reminders.
- Send a system notification first, then show a full-screen reminder after a configurable grace period.
- Customize achievement goals for water, coffee, tea, or other drinks.
- Switch the app interface between English and Chinese.
- Smooth animated transitions between app pages.

## Run Locally

```bash
swift run DrinkMore
```

The app asks for notification permission on first launch.

## Package a Release

```bash
./Scripts/package-release.sh
```

The script creates:

- `dist/DrinkMore.app`
- `dist/DrinkMore-macOS.zip`

Upload the zip file to a GitHub Release. Users can download it, unzip it, and open `DrinkMore.app`.

## Logo

The logo was generated with Codex built-in imagegen. The source image is `Assets/DrinkMoreLogo.png`, and the macOS icon is `Assets/DrinkMore.icns`.

## macOS Notification Behavior

macOS does not give ordinary apps a reliable way to know whether a notification was dismissed. DrinkMore uses a clearer interaction model: after the notification is delivered, the app waits for you to click Done, Snooze, log a drink, or handle the full-screen reminder. If no action happens within the grace period, the full-screen reminder appears.

## 中文说明

DrinkMore 是一个开源 macOS 喝水提醒工具。它常驻菜单栏，可以记录真实杯子的容量，统计每天喝了多少水、咖啡、茶或其他饮品，并支持通知提醒和全屏强提醒。

当前功能：

- 新增和编辑杯子，包括名称、类型、容量。
- 从主窗口或菜单栏快速记录饮品。
- 统计今天喝了多少杯、总共摄入多少 ml。
- 自定义倒计时提醒。
- 先发系统通知，超过宽限时间后弹出全屏提醒。
- 自定义水、咖啡、茶或其他饮品的成就目标。
- App 界面支持英文和中文切换。
- 页面切换带动画。

本地运行：

```bash
swift run DrinkMore
```

打包 Release：

```bash
./Scripts/package-release.sh
```
