# DrinkMore

![DrinkMore logo](Assets/DrinkMoreLogo.png)

DrinkMore 是一个开源 macOS 喝水提醒小工具，目标是轻量、常驻菜单栏、记录真实杯子容量，并且能在通知没被处理时弹出强提醒。

## 当前功能

- 记录多个杯子：水杯、咖啡杯、马克杯、随行杯，也可以自己新增和修改容量
- 按杯子快速记录：每天每个杯子喝了几杯、总共喝了多少 ml
- 区分类型：水、咖啡、茶、其他
- 自定义倒计时提醒
- 先发系统通知，超过宽限时间后弹出全屏提醒
- 成就系统：可以自定义每天喝水目标、咖啡目标或其他饮品目标
- 菜单栏快速记录和稍后提醒

## 本地运行

```bash
swift run DrinkMore
```

第一次运行时，系统会请求通知权限。

## 打包 Release

```bash
./Scripts/package-release.sh
```

脚本会生成：

- `dist/DrinkMore.app`
- `dist/DrinkMore-macOS.zip`

把 zip 上传到 GitHub Release，用户下载后解压并拖进 Applications 即可。

## Logo

Logo 使用 Codex 内置 imagegen 生成，源图在 `Assets/DrinkMoreLogo.png`，macOS 图标在 `Assets/DrinkMore.icns`。

## 说明

macOS 没有给普通 App 一个稳定接口来判断用户是否“消掉”了通知。DrinkMore 采用更可靠的交互判断：通知发出后，如果你没有在 App、菜单栏或全屏页点击“我喝了”或“稍后”，到达宽限时间就会弹全屏提醒。
