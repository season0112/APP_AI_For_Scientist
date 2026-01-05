# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI-based application called "AI for Scientist" targeting Apple platforms (iOS/macOS). The project uses Xcode as its build system and follows standard Apple platform development patterns.

## Build and Development Commands

### Quick Start
- Open project in Xcode: `open "AI for Scientist.xcodeproj"` (or use `./run.sh`)
- Build from command line: `xcodebuild -project "AI for Scientist.xcodeproj" -scheme "AI for Scientist" build`

### Running the App
- In Xcode: Select target device/simulator and press `Cmd+R`
- List available simulators: `xcrun simctl list devices available`
- Boot a simulator: `xcrun simctl boot "iPhone 15"`
- Run tests: `xcodebuild test -project "AI for Scientist.xcodeproj" -scheme "AI for Scientist" -destination 'platform=iOS Simulator,name=iPhone 15'`

### Testing
- Run all tests: `xcodebuild test -project "AI for Scientist.xcodeproj" -scheme "AI for Scientist" -destination 'platform=iOS Simulator,name=iPhone 15'`
- Run unit tests only: `xcodebuild test -project "AI for Scientist.xcodeproj" -scheme "AI for Scientist" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:AI_for_ScientistTests`
- Run UI tests only: `xcodebuild test -project "AI for Scientist.xcodeproj" -scheme "AI for Scientist" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:AI_for_ScientistUITests`
- Run a single test: `xcodebuild test -project "AI for Scientist.xcodeproj" -scheme "AI for Scientist" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:AI_for_ScientistTests/ModelTests/testPaperInitialization`

Note: Adjust the `-destination` parameter based on the target platform (iOS/macOS). Available simulators can vary by Xcode version.

### Available Schemes and Targets
- **Scheme**: "AI for Scientist" (single scheme)
- **Targets**:
  - `AI for Scientist`: Main application target
  - `AI for ScientistTests`: Unit test target
  - `AI for ScientistUITests`: UI test target
- **Build Configurations**: Debug, Release

## Code Architecture

### Architecture Pattern: MVVM
The app follows the Model-View-ViewModel (MVVM) architecture pattern for clear separation of concerns:
- **Models**: Data structures and business logic
- **Views**: SwiftUI UI components
- **ViewModels**: State management and business logic coordination
- **Services**: External API interactions and data processing

### Project Structure
```
AI for Scientist/
├── AI for Scientist/          # Main application target
│   ├── Models/                # Data models
│   │   ├── ResearchField.swift    # Scientific domain representation
│   │   ├── Paper.swift            # Scientific paper with metadata
│   │   ├── Newsletter.swift       # Generated newsletter model
│   │   └── UserProfile.swift      # User preferences and data
│   │
│   ├── Views/                 # SwiftUI views
│   │   ├── HomeView.swift         # Home screen with quick actions
│   │   ├── FieldSelectionView.swift   # Research field picker
│   │   ├── PDFUploadView.swift    # PDF upload interface
│   │   ├── NewsletterGenerationView.swift  # Newsletter creation
│   │   ├── NewsletterListView.swift    # Saved newsletters list
│   │   ├── NewsletterDetailView.swift  # Newsletter detail view
│   │   └── SettingsView.swift     # App settings
│   │
│   ├── ViewModels/            # View models (state management)
│   │   ├── MainViewModel.swift    # App-wide state and user profile
│   │   ├── PDFUploadViewModel.swift   # PDF upload workflow
│   │   ├── NewsletterGenerationViewModel.swift  # Newsletter creation
│   │   └── NewsletterListViewModel.swift    # Newsletter management
│   │
│   ├── Services/              # Business logic services
│   │   ├── PDFService.swift       # PDF upload, parsing, text extraction
│   │   ├── LiteratureSearchService.swift  # arXiv search and AI agents
│   │   └── NewsletterService.swift    # Newsletter generation
│   │
│   ├── Utils/                 # Utilities and extensions
│   │   └── Extensions.swift       # Helper extensions for common types
│   │
│   ├── Config/                # Configuration
│   │   └── AppConfig.swift        # App-wide constants and settings
│   │
│   ├── Assets.xcassets/       # Images and color assets
│   ├── AI_for_ScientistApp.swift  # App entry point with @main
│   └── ContentView.swift      # Root view with TabView navigation
│
├── AI for ScientistTests/     # Unit tests
│   ├── ModelTests.swift       # Model object tests
│   ├── ServiceTests.swift     # Service layer tests
│   ├── ViewModelTests.swift   # ViewModel tests
│   └── ExtensionTests.swift   # Extension utility tests
│
├── AI for ScientistUITests/   # UI tests
│
├── .claude/                   # Claude agent configurations
│   ├── agents/                # AI agent definitions
│   │   ├── literature-search.json
│   │   └── newsletter-generator.json
│   ├── commands/              # CLI commands
│   │   ├── search-papers.md
│   │   └── generate-newsletter.md
│   └── skills/                # Reusable skills
│       └── paper-analysis.json
│
├── README.md                  # Project documentation
└── CLAUDE.md                  # This file
```

### Key Components

#### Models (`AI for Scientist/Models/`)
- **ResearchField**: Represents scientific domains with keywords for search
- **Paper**: Scientific paper with metadata (title, authors, abstract, PDF paths, keywords)
- **Newsletter**: Generated newsletter containing curated papers and summary
- **UserProfile**: User preferences, uploaded papers, saved newsletters, notification settings

#### Services (`AI for Scientist/Services/`)
- **PDFService**: Handles PDF import, text extraction, metadata parsing (title, authors, abstract)
- **LiteratureSearchService**: Searches arXiv API, integrates with Claude agents for semantic search
- **NewsletterService**: Generates newsletters, creates HTML/PDF output, manages storage

#### ViewModels (`AI for Scientist/ViewModels/`)
- **MainViewModel**: App-wide state, user profile management, tab navigation
- **PDFUploadViewModel**: PDF upload workflow, progress tracking, metadata extraction
- **NewsletterGenerationViewModel**: Newsletter creation flow (field selection, paper search, generation)
- **NewsletterListViewModel**: Manages saved newsletters, loading, deletion

#### Views (`AI for Scientist/Views/`)
All views use SwiftUI and follow these patterns:
- Use `@EnvironmentObject` for MainViewModel access
- Use `@StateObject` for local ViewModels
- Include PreviewProvider for Xcode previews
- Handle errors with alerts

### Data Flow
1. **User Input** → Views capture user interaction
2. **State Update** → ViewModels update @Published properties
3. **Service Call** → ViewModels call Services for business logic
4. **Model Update** → Services return updated Models
5. **View Refresh** → SwiftUI automatically re-renders Views

### Key Patterns
- **Singleton Services**: All services use `shared` singleton pattern
- **Async/Await**: All network and file operations use Swift concurrency
- **Combine**: ViewModels use @Published properties for reactive updates
- **Environment Objects**: MainViewModel passed through environment
- **Declarative UI**: All views built with SwiftUI declarative syntax

### Claude Agent Integration

The app is designed to integrate with Claude agents for AI-powered features. Agent configurations are stored in `.claude/` directory:

**Literature Search Agent** (`.claude/agents/literature-search.json`):
- Performs semantic paper search using Claude Sonnet 4.5
- Relevance scoring and paper ranking
- Searches arXiv (primary), PubMed (planned)
- Returns structured JSON with papers, relevance scores, keywords
- Integration point: `LiteratureSearchService.searchWithAIAgent()`

**Newsletter Generator Agent** (`.claude/agents/newsletter-generator.json`):
- Generates customized research newsletters
- Summary generation and content curation
- Insight extraction from multiple papers
- Integration point: `NewsletterService.generateSummary()`

**Paper Analysis Skill** (`.claude/skills/paper-analysis.json`):
- Five actions: extract_keywords, summarize_abstract, identify_methodology, extract_citations, classify_field
- Uses Claude Sonnet 4.5 with caching enabled
- Returns structured data (keywords with confidence, summaries, methodologies, citations)
- Integration point: Custom service methods

**CLI Commands** (`.claude/commands/`):
- `/search-papers <query> [--field <field>] [--max-results <n>]`: Search for papers
- `/generate-newsletter --field <field> [--paper <id>] [--papers <ids>]`: Generate newsletter

**Current Status**: Agent configurations exist but require full API integration. Service methods contain placeholder implementations that need to be connected to Claude API endpoints.

### Important Notes
- **File paths**: Directory names contain spaces, so always quote paths in command-line tools (e.g., `"AI for Scientist.xcodeproj"`)
- **Module name**: Test files import the module as `AI_for_Scientist` (with underscores, not spaces)
- **Target membership**: When creating new Swift files via Xcode, ensure they're added to the correct target (main app, tests, or UI tests)
- **iOS version**: Minimum deployment target is iOS 16.0+ for async/await and modern SwiftUI features
- **Local storage**: Papers and newsletters stored in Documents directory via FileManager
- **User preferences**: UserProfile encoded as JSON and persisted in UserDefaults
- **Claude Code permissions**: `.claude/settings.local.json` grants auto-approval for `xcodebuild`, `xcrun simctl`, and `cat` commands

### Adding New Features
When adding features, follow this workflow:
1. Create/update Model objects in `Models/`
2. Add business logic in `Services/`
3. Create ViewModel in `ViewModels/`
4. Build SwiftUI View in `Views/`
5. Add unit tests in `AI for ScientistTests/`
6. Update this CLAUDE.md file with new components
