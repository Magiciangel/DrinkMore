# Similar Projects

这份笔记记录 DrinkMore 可以参考的开源项目。只参考产品思路、工程结构和 API 用法，不直接复制大段代码。

## Mizu

- Repo: https://github.com/esoxjem/Mizu
- 类型：原生 Swift macOS 喝水提醒 App
- 许可证：MIT
- 可参考点：
  - Swift 原生菜单栏 App 结构
  - `UNUserNotificationCenter` 通知封装
  - 睡眠/唤醒时停止和重启提醒
  - `SMAppService.mainApp` 实现开机启动
  - Sparkle + appcast 做自动更新

## Water Reminder Desktop App

- Repo: https://github.com/AnukarOP/Water-Reminder-desktop-app
- 类型：Electron 桌面喝水提醒 App
- 可参考点：
  - 倒计时 UI
  - 每日目标、连续天数和成就展示
  - 通知后在主界面显示待处理提醒

## swiftDialog

- Repo: https://github.com/swiftDialog/swiftDialog
- 类型：SwiftUI macOS 通知和弹窗工具
- 许可证：MIT
- 可参考点：
  - 通知 action/category 的处理
  - 强提示窗口的层级和多 Space 行为
  - Release 下载和文档组织方式

## Jamf Notifier

- Repo: https://github.com/jamf/Notifier
- 类型：macOS 通知工具
- 许可证：Apache-2.0
- 可参考点：
  - alert/banner 通知差异
  - 删除已发送通知
  - 通知权限和系统设置说明

## 已合入 DrinkMore 的参考点

- 通知增加“已处理”和“稍后 10 分钟”按钮
- 用户处理提醒后清理已发送通知
- Mac 睡眠时暂停提醒，唤醒后重新安排提醒

## 后续适合做

- 开机启动开关
- GitHub Actions 自动打包 zip
- Sparkle 自动更新
- 连续达标天数和里程碑成就
- App 图标和菜单栏模板图标
