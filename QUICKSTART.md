# AI for Scientist - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Open the Project
```bash
cd "AI for Scientist"
open "AI for Scientist.xcodeproj"
```

### Step 2: Select Target
- In Xcode, select a simulator or device (e.g., iPhone 15)
- Press `Cmd+R` to build and run

### Step 3: Explore the App
The app will launch with 4 main tabs:

#### 🏠 Home Tab
- View welcome message and onboarding
- Quick actions: Upload Paper, Generate Newsletter
- Recent papers and newsletters preview

#### 📄 Upload Tab
- Tap "Upload PDF Paper" to select a PDF
- App automatically extracts title, authors, abstract
- View your uploaded papers list

#### 📰 Newsletters Tab
- Tap "+" to create a new newsletter
- Follow 4-step process:
  1. Select research field
  2. (Optional) Select your paper
  3. Search for related papers
  4. Generate newsletter
- View saved newsletters

#### ⚙️ Settings Tab
- Manage research fields
- Configure notifications
- View storage statistics

## 📱 Testing the Features

### Test PDF Upload
1. Go to Upload tab
2. Tap "Upload PDF Paper"
3. Select any PDF file
4. View extracted metadata
5. Tap "Generate Newsletter" to continue

### Test Paper Search
1. Go to Newsletters tab → Tap "+"
2. Select a research field (e.g., "Artificial Intelligence")
3. Tap "Auto Search"
4. Wait for results from arXiv
5. Review found papers
6. Tap "Generate Newsletter"

### Test Newsletter Generation
1. Complete the search (see above)
2. Tap "Generate Newsletter"
3. Wait for generation (uses AI summary)
4. View generated newsletter
5. Tap "View Newsletter" to see details

## 🧪 Run Tests
```bash
# Run all tests
xcodebuild test -project "AI for Scientist.xcodeproj" \
  -scheme "AI for Scientist" \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Or use Xcode: Cmd+U
```

## 📁 Project Structure Overview

```
AI for Scientist/
├── Models/          # Data structures
├── Views/           # UI components
├── ViewModels/      # State management
├── Services/        # Business logic
├── Utils/           # Helper functions
├── Config/          # App configuration
└── .claude/         # AI agent configs
```

## 🤖 Claude Agent Integration

The app is ready for Claude agent integration:

### Literature Search Agent
- File: `.claude/agents/literature-search.json`
- Purpose: Semantic paper search
- Integration point: `LiteratureSearchService.searchWithAIAgent()`

### Newsletter Generator Agent
- File: `.claude/agents/newsletter-generator.json`
- Purpose: Generate summaries and insights
- Integration point: `NewsletterService.generateSummary()`

### Paper Analysis Skill
- File: `.claude/skills/paper-analysis.json`
- Purpose: Extract keywords, summarize, classify
- Integration: Custom service methods

## 🔧 Common Commands

### Build
```bash
xcodebuild -project "AI for Scientist.xcodeproj" \
  -scheme "AI for Scientist" build
```

### Test Specific Suite
```bash
xcodebuild test -project "AI for Scientist.xcodeproj" \
  -scheme "AI for Scientist" \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:AI_for_ScientistTests/ModelTests
```

### Clean Build
```bash
xcodebuild clean -project "AI for Scientist.xcodeproj" \
  -scheme "AI for Scientist"
```

## 📚 Documentation Files

- **README.md**: Complete documentation
- **CLAUDE.md**: Claude Code guidance
- **PROJECT_STRUCTURE.md**: File organization
- **IMPLEMENTATION_SUMMARY.md**: What's implemented
- **QUICKSTART.md**: This file

## ✅ What Works Out of the Box

✅ Research field selection
✅ PDF upload and metadata extraction
✅ arXiv paper search
✅ Related paper discovery
✅ Newsletter generation with HTML
✅ Newsletter storage and management
✅ User profile persistence
✅ All UI flows and navigation

## 🔄 What Needs API Keys

The following features have placeholder implementations ready for API integration:

- Claude agent literature search
- Claude agent newsletter generation
- Advanced paper analysis

## 💡 Tips

1. **Test with Real PDFs**: Upload actual research papers to see metadata extraction
2. **Try Different Fields**: Each field has specific keywords for better search
3. **Use Auto Search**: Quick way to find related papers
4. **Save Newsletters**: Generated newsletters are saved automatically
5. **Check Settings**: Configure notification frequency and manage fields

## 🐛 Troubleshooting

### Build Errors
- Clean build folder: `Cmd+Shift+K`
- Restart Xcode
- Check that all files are added to target

### PDF Upload Issues
- Ensure PDF is not password-protected
- Check file size (max 10MB)
- Verify PDF contains text (not just images)

### Search Not Working
- Check internet connection
- Verify arXiv API is accessible
- Try broader search terms

## 📞 Need Help?

- Check README.md for detailed documentation
- Review code comments in Swift files
- See CLAUDE.md for architecture details
- Check IMPLEMENTATION_SUMMARY.md for feature list

## 🎯 Next Steps

1. ✅ Build and run the app
2. ✅ Test all features manually
3. ✅ Run unit tests
4. 🔄 Add Claude API keys (optional)
5. 🔄 Customize research fields
6. 🔄 Add more data sources
7. 🔄 Deploy to TestFlight

---

**Ready to start?** Open Xcode and press `Cmd+R`! 🚀
