# AI for Scientist - Project Structure

Complete overview of the project structure and file organization.

## Directory Tree

```
AI for Scientist/
│
├── AI for Scientist/                      # Main Application Target
│   │
│   ├── Models/                            # Data Models
│   │   ├── ResearchField.swift            # Research field/domain model
│   │   ├── Paper.swift                    # Scientific paper model
│   │   ├── Newsletter.swift               # Newsletter model with HTML generation
│   │   └── UserProfile.swift              # User preferences and data
│   │
│   ├── Views/                             # SwiftUI Views
│   │   ├── HomeView.swift                 # Home screen with quick actions
│   │   ├── FieldSelectionView.swift       # Research field selection
│   │   ├── PDFUploadView.swift            # PDF upload interface
│   │   ├── NewsletterGenerationView.swift # Newsletter creation workflow
│   │   ├── NewsletterListView.swift       # List of saved newsletters
│   │   ├── NewsletterDetailView.swift     # Newsletter detail view
│   │   └── SettingsView.swift             # Settings and preferences
│   │
│   ├── ViewModels/                        # View Models (MVVM)
│   │   ├── MainViewModel.swift            # App-wide state management
│   │   ├── PDFUploadViewModel.swift       # PDF upload workflow logic
│   │   ├── NewsletterGenerationViewModel.swift  # Newsletter generation logic
│   │   └── NewsletterListViewModel.swift  # Newsletter list management
│   │
│   ├── Services/                          # Business Logic Services
│   │   ├── PDFService.swift               # PDF operations (import, parse, extract)
│   │   ├── LiteratureSearchService.swift  # Paper search (arXiv + AI agents)
│   │   └── NewsletterService.swift        # Newsletter generation and storage
│   │
│   ├── Utils/                             # Utilities
│   │   └── Extensions.swift               # Helper extensions (Date, String, URL, etc.)
│   │
│   ├── Config/                            # Configuration
│   │   └── AppConfig.swift                # App constants and settings
│   │
│   ├── Assets.xcassets/                   # Assets
│   │   ├── AccentColor.colorset/
│   │   ├── AppIcon.appiconset/
│   │   └── Contents.json
│   │
│   ├── AI_for_ScientistApp.swift          # App entry point (@main)
│   └── ContentView.swift                  # Root view (TabView)
│
├── AI for ScientistTests/                 # Unit Tests
│   ├── AI_for_ScientistTests.swift        # Default test file
│   ├── ModelTests.swift                   # Model object tests
│   ├── ServiceTests.swift                 # Service layer tests
│   ├── ViewModelTests.swift               # ViewModel tests
│   └── ExtensionTests.swift               # Extension utility tests
│
├── AI for ScientistUITests/               # UI Tests
│   ├── AI_for_ScientistUITests.swift
│   └── AI_for_ScientistUITestsLaunchTests.swift
│
├── .claude/                               # Claude Agent Configurations
│   ├── agents/                            # AI Agent Definitions
│   │   ├── literature-search.json         # Literature search agent
│   │   └── newsletter-generator.json      # Newsletter generator agent
│   ├── commands/                          # CLI Commands
│   │   ├── search-papers.md               # Search papers command
│   │   └── generate-newsletter.md         # Generate newsletter command
│   └── skills/                            # Reusable Skills
│       └── paper-analysis.json            # Paper analysis skill
│
├── AI for Scientist.xcodeproj/            # Xcode Project
│   ├── project.pbxproj
│   └── project.xcworkspace/
│
├── README.md                              # Project documentation
├── CLAUDE.md                              # Claude Code guidance
└── PROJECT_STRUCTURE.md                   # This file
```

## File Count Summary

- **Models**: 4 files
- **Views**: 7 files
- **ViewModels**: 4 files
- **Services**: 3 files
- **Utils**: 1 file
- **Config**: 1 file
- **Tests**: 4 test suites
- **Claude Configs**: 5 configurations
- **Total Swift Files**: 24+ files

## Component Relationships

### Data Flow

```
User Interaction
    ↓
Views (SwiftUI)
    ↓
ViewModels (@Published state)
    ↓
Services (Business Logic)
    ↓
Models (Data Structures)
    ↓
Storage (FileManager/UserDefaults)
```

### Dependency Graph

```
Views
  ↓
ViewModels
  ↓
Services → Models
  ↓
External APIs (arXiv, Claude Agents)
```

## Key Features by Module

### Models Module
- ✅ ResearchField with predefined domains
- ✅ Paper with metadata and computed properties
- ✅ Newsletter with HTML generation
- ✅ UserProfile with preferences

### Services Module
- ✅ PDF import and text extraction
- ✅ arXiv API integration
- ✅ Claude agent placeholders
- ✅ Newsletter generation and storage
- ✅ XML parsing for arXiv responses

### ViewModels Module
- ✅ State management with @Published
- ✅ Error handling
- ✅ Async/await operations
- ✅ User profile persistence

### Views Module
- ✅ Tab-based navigation
- ✅ PDF file picker integration
- ✅ Dynamic lists and forms
- ✅ Preview providers for all views
- ✅ Alert and sheet presentations

### Tests Module
- ✅ Model tests (initialization, computed properties)
- ✅ Service tests (singleton, error handling)
- ✅ ViewModel tests (state management, async operations)
- ✅ Extension tests (utilities)

## Integration Points

### External APIs
1. **arXiv API**: `https://export.arxiv.org/api/query`
   - File: `Services/LiteratureSearchService.swift`
   - Method: `searchArXiv(keywords:field:maxResults:)`

2. **Claude Agents**: `.claude/agents/`
   - Literature Search: `searchWithAIAgent(query:context:)`
   - Newsletter Generation: `generateSummary(userPaper:relatedPapers:field:)`

### Local Storage
1. **FileManager**: Documents directory
   - Papers: `Documents/Papers/`
   - Newsletters: `Documents/Newsletters/`

2. **UserDefaults**: User preferences
   - Key: `userProfile`
   - Format: JSON-encoded UserProfile

## Build Targets

1. **AI for Scientist** (Main App)
   - Platform: iOS 16.0+
   - Language: Swift 5.9+
   - Framework: SwiftUI

2. **AI for ScientistTests** (Unit Tests)
   - Framework: XCTest
   - Test Files: 4

3. **AI for ScientistUITests** (UI Tests)
   - Framework: XCTest
   - Test Files: 2

## Next Steps for Development

### Immediate
- [ ] Add actual Claude agent API integration
- [ ] Implement proper PDF to HTML conversion
- [ ] Add network error retry logic
- [ ] Implement caching for search results

### Future Enhancements
- [ ] Add more data sources (PubMed, Google Scholar)
- [ ] Implement PDF annotation
- [ ] Add collaborative features
- [ ] Export to reference managers (BibTeX)
- [ ] Add advanced search filters
- [ ] Implement dark mode
- [ ] iPad optimization

## Code Style Guidelines

### Swift Conventions
- Use meaningful variable names
- Add documentation comments for public APIs
- Follow MVVM separation
- Use async/await for async operations
- Prefer structs over classes for models
- Use extensions to organize code

### SwiftUI Conventions
- Extract complex views into separate components
- Use PreviewProvider for all views
- Handle loading and error states
- Use @Published for reactive state
- Prefer @EnvironmentObject for shared state

### Testing Conventions
- Test all model computed properties
- Mock external dependencies
- Test error handling paths
- Use descriptive test names
- Group related tests with MARK comments
