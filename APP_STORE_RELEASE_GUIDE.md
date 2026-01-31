# AI for Scientist - App Store 发布指南

## 当前配置
- **应用名称**: AI for Scientist
- **Bundle ID**: Lumio.AI-for-Scientist
- **版本**: 1.0
- **构建号**: 1
- **开发团队**: S4383D398F

---

## 第一步：准备资源文件

### 1. 应用图标
**必需**: 1024x1024 PNG 图标（无透明度）

**如何添加**:
1. 在 Xcode 中打开项目
2. 导航到 `AI for Scientist/Assets.xcassets`
3. 点击 `AppIcon`
4. 拖放你的 1024x1024 图标文件

**设计建议**:
- 使用科学/研究相关的图标元素
- 简洁、易识别
- 避免文字（图标很小时难以阅读）

### 2. App Store 截图

**必需尺寸**:
- **iPhone 6.7"** (1290 x 2796 pixels) - iPhone 15 Pro Max, 14 Pro Max, 13 Pro Max
- **iPhone 6.5"** (1284 x 2778 pixels) - iPhone 11 Pro Max, XS Max

**数量**: 至少 3 张，最多 10 张

**如何生成截图**:
1. 在模拟器中运行应用：
   ```bash
   # 启动 iPhone 15 Pro Max 模拟器
   xcrun simctl boot "iPhone 15 Pro Max"
   ```
2. 在 Xcode 中选择该模拟器并运行应用
3. 在模拟器中按 `Cmd + S` 保存截图
4. 截图保存在桌面

**推荐截图内容**:
1. 主屏幕（Home View）
2. PDF 上传界面（Upload Papers）
3. Newsletter 生成界面（带搜索结果）
4. 生成的 Newsletter 详情
5. 设置界面

---

## 第二步：在 Xcode 中配置

### 1. 更新版本信息
1. 在 Xcode 中选择项目
2. 选择 target "AI for Scientist"
3. 在 "General" 标签：
   - **Display Name**: AI for Scientist
   - **Version**: 1.0
   - **Build**: 1

### 2. 配置 Signing & Capabilities
1. 选择 "Signing & Capabilities" 标签
2. 确保:
   - ✅ "Automatically manage signing" 已勾选
   - ✅ Team: 选择你的开发团队
   - ✅ Bundle Identifier: Lumio.AI-for-Scientist
   - ✅ Signing Certificate: 自动选择

### 3. 设置部署目标
1. 在 "General" 标签中
2. 确保 "Minimum Deployments" 设置为 iOS 16.0 或更高

---

## 第三步：创建 Archive

### 1. 选择目标设备
在 Xcode 顶部工具栏：
- 从设备/模拟器选择器中选择 **"Any iOS Device (arm64)"**

### 2. 创建 Archive
```bash
# 方法 1: 使用 Xcode 菜单
# Product > Archive
# 等待编译完成（可能需要几分钟）

# 方法 2: 使用命令行
xcodebuild -project "AI for Scientist.xcodeproj" \\
  -scheme "AI for Scientist" \\
  -configuration Release \\
  -archivePath "./build/AI_for_Scientist.xcarchive" \\
  archive
```

### 3. 验证 Archive
Archive 完成后，Xcode Organizer 会自动打开：
1. 选择你刚创建的 Archive
2. 点击 **"Validate App"** 进行预验证
   - 选择你的团队和分发选项
   - 等待验证完成
   - 如果有错误，解决后重新 Archive

---

## 第四步：上传到 App Store Connect

### 1. 分发 Archive
在 Xcode Organizer 中：
1. 选择你的 Archive
2. 点击 **"Distribute App"**
3. 选择 **"App Store Connect"**
4. 选择 **"Upload"**
5. 选择分发选项：
   - ✅ Upload your app's symbols
   - ✅ Manage Version and Build Number (推荐自动管理)
6. 选择签名选项：
   - ✅ Automatically manage signing (推荐)
7. 点击 **"Upload"**
8. 等待上传完成（可能需要几分钟）

### 2. 等待处理
- 上传后，App Store Connect 需要处理你的构建
- 这可能需要 **几分钟到几小时**
- 你会收到邮件通知

---

## 第五步：在 App Store Connect 中配置

### 1. 访问 App Store Connect
1. 打开 https://appstoreconnect.apple.com
2. 使用你的 Apple ID 登录

### 2. 创建新应用
1. 点击 **"我的 App"**
2. 点击 **"+"** → **"新建 App"**
3. 填写信息：
   - **平台**: iOS
   - **名称**: AI for Scientist
   - **主要语言**: 简体中文 或 英语
   - **Bundle ID**: Lumio.AI-for-Scientist
   - **SKU**: 可以使用 Bundle ID (Lumio.AI-for-Scientist)
   - **用户访问权限**: 完全访问权限

### 3. 填写应用信息

#### 3.1 App 信息
- **名称**: AI for Scientist
- **副标题** (30字符): Research Newsletter Generator
- **类别**:
  - 主要类别: 效率 (Productivity)
  - 次要类别: 教育 (Education)

#### 3.2 定价与销售范围
- **价格**: 免费 或 设置价格
- **销售范围**: 选择你要上架的国家/地区

#### 3.3 App 隐私
**必填**: 隐私详细信息
1. 点击 **"开始"**
2. 回答隐私问卷：
   - **收集的数据类型**: 无（如果你不收集用户数据）
   - **数据用途**: 应用功能
   - **第三方数据共享**: 无（如果不共享）

**建议创建隐私政策页面**:
- 可以使用免费工具生成：https://www.privacypolicygenerator.info
- 上传到你的网站或 GitHub Pages
- 填写 URL 到 App Store Connect

#### 3.4 应用版本信息
1. 选择 **"1.0 准备提交"**
2. 填写以下信息：

**截图和预览**:
- 上传你准备的 iPhone 截图
- 按照功能流程排序

**宣传文本** (170字符):
```
自动生成个性化科研文献通讯。上传论文，AI 智能搜索相关研究，一键生成精美 Newsletter。
```

**描述** (最多4000字符):
```
AI for Scientist 是一款专为科研人员设计的智能文献管理工具。

【核心功能】
📄 PDF 上传：轻松导入你的研究论文
🔍 智能搜索：自动搜索 arXiv 等数据库的相关文献
📰 Newsletter 生成：一键生成精美的研究通讯
📚 文献管理：保存和管理你的论文库
⚙️ 自定义领域：选择你关注的研究领域

【适用人群】
✓ 科研人员
✓ 研究生
✓ 学术研究者
✓ 需要追踪最新文献的专业人士

【特色】
• 简洁易用的界面
• 强大的文献搜索能力
• 美观的 Newsletter 生成
• 支持多个研究领域
• 离线保存和管理

立即下载，让 AI 助力你的科研工作！
```

**关键词** (用逗号分隔，最多100字符):
```
科研,论文,文献,研究,newsletter,arXiv,学术,AI
```

**支持 URL**:
- 创建一个简单的支持页面（可以用 GitHub Pages）
- 或者使用你的个人网站

**营销 URL** (可选):
- 你的应用宣传页面

**版本**:
- 1.0

**版权**:
- 2026 [你的名字或公司名]

**Apple ID** (App Store 登录账号需求):
- 如果应用需要登录才能使用，提供测试账号
- 如果不需要登录，选择 **"不需要登录"**

**联系信息**:
- 姓名
- 电话号码
- 电子邮件地址

**备注** (可选):
- 给审核人员的特殊说明

**App 分级**:
1. 点击 **"编辑"**
2. 回答内容分级问卷
3. 通常科研应用会被评为 **4+**

#### 3.5 构建版本
1. 在 **"构建版本"** 部分，点击 **"+"**
2. 选择你上传的构建版本（1.0, build 1）
3. 如果看不到构建版本，等待 Apple 处理（检查邮件）

---

## 第六步：提交审核

### 1. 最终检查
确认所有必填项都已完成：
- ✅ 应用图标
- ✅ 截图（至少3张）
- ✅ 应用描述
- ✅ 关键词
- ✅ 支持 URL
- ✅ 隐私政策
- ✅ 构建版本已选择
- ✅ 定价已设置

### 2. 提交审核
1. 点击右上角 **"提交以供审核"**
2. 回答 **"出口合规信息"**:
   - 你的应用是否使用加密？
   - 通常选择 **"否"**（除非使用了特殊加密）
3. 回答 **"广告标识符 (IDFA)"**:
   - 你的应用是否使用广告标识符？
   - 通常选择 **"否"**
4. 点击 **"提交"**

### 3. 审核过程
- **审核时间**: 通常 24-48 小时
- **状态追踪**:
  - 等待审核 (Waiting for Review)
  - 正在审核 (In Review)
  - 等待开发者发布 (Pending Developer Release)
  - 可供销售 (Ready for Sale)

### 4. 可能的审核结果

**✅ 批准**:
- 应用自动发布（或手动发布，取决于你的设置）
- 恭喜！你的应用已上架 App Store

**❌ 被拒**:
- 查看拒绝原因
- 修复问题
- 重新提交

**常见拒绝原因**:
- 缺少隐私政策
- 应用崩溃或有 bug
- 界面不完整
- 缺少必要的说明
- 违反 App Store 审核指南

---

## 第七步：发布后

### 1. 监控
- 查看 App Store Connect 中的分析数据
- 关注用户评价和反馈
- 监控崩溃报告

### 2. 更新
发布更新版本：
1. 在代码中修复 bug 或添加新功能
2. 更新版本号（例如 1.0 → 1.1）
3. 重复上述 Archive 和提交流程

---

## 常见问题

### Q: 审核需要多久？
A: 通常 24-48 小时，但可能需要更长时间（最多一周）

### Q: 如何生成隐私政策？
A: 使用在线工具：
- https://www.privacypolicygenerator.info
- https://www.freeprivacypolicy.com

### Q: 应用被拒怎么办？
A:
1. 仔细阅读拒绝原因
2. 修复问题
3. 在"解决方案中心"回复审核团队
4. 重新提交

### Q: 需要提供测试账号吗？
A: 如果你的应用不需要登录即可使用主要功能，则不需要

### Q: 可以修改应用名称吗？
A: 可以，但需要重新提交审核

---

## 快速命令参考

### 清理构建
```bash
xcodebuild -project "AI for Scientist.xcodeproj" -scheme "AI for Scientist" clean
```

### 创建 Archive (命令行)
```bash
xcodebuild -project "AI for Scientist.xcodeproj" \\
  -scheme "AI for Scientist" \\
  -configuration Release \\
  -archivePath "./build/AI_for_Scientist.xcarchive" \\
  archive
```

### 查看 Archive
```bash
open ~/Library/Developer/Xcode/Archives
```

---

## 有用的链接

- **App Store Connect**: https://appstoreconnect.apple.com
- **开发者账号**: https://developer.apple.com/account
- **App Store 审核指南**: https://developer.apple.com/app-store/review/guidelines/
- **人机界面指南**: https://developer.apple.com/design/human-interface-guidelines/
- **App Store 截图规格**: https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications

---

## 支持

如果遇到问题：
1. 查看 Apple 官方文档
2. 在 Apple Developer Forums 提问
3. 联系 Apple Developer Support

祝你发布顺利！🎉
