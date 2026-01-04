# AI for Scientist

An iOS application that leverages AI to help scientists discover and curate relevant research literature. Upload your papers, select your research fields, and receive personalized newsletters with related publications from arXiv and other sources.

## Features

- **Research Field Selection**: Choose from predefined scientific domains or create custom fields
- **PDF Upload & Analysis**: Upload your papers and automatically extract metadata (title, authors, abstract, keywords)
- **AI-Powered Literature Search**: Find related papers using intelligent semantic search
- **Newsletter Generation**: Create customized newsletters with curated research papers
- **Offline Storage**: All papers and newsletters are stored locally on your device
- **Notification Support**: Get reminders for new research updates (configurable frequency)

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture with clear separation of concerns:

```
AI for Scientist/
├── Models/              # Data models (Paper, Newsletter, ResearchField, UserProfile)
├── Views/               # SwiftUI views
├── ViewModels/          # Business logic and state management
├── Services/            # Service layer (PDF, Search, Newsletter)
├── Utils/               # Extensions and helpers
└── Config/              # App configuration
```

### Key Components

#### Models
- **ResearchField**: Represents scientific domains with keywords
- **Paper**: Scientific paper with metadata (title, authors, abstract, PDF)
- **Newsletter**: Generated newsletter containing curated papers
- **UserProfile**: User preferences and saved data

#### Services
- **PDFService**: Handle PDF upload, text extraction, and metadata parsing
- **LiteratureSearchService**: Search arXiv and other sources for related papers
- **NewsletterService**: Generate and manage newsletters

#### ViewModels
- **MainViewModel**: App-wide state and user profile management
- **PDFUploadViewModel**: PDF upload workflow
- **NewsletterGenerationViewModel**: Newsletter creation process
- **NewsletterListViewModel**: Manage saved newsletters

## Prerequisites

- iOS 16.0+
- Xcode 14.0+
- Swift 5.0+

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/ai-for-scientist.git
cd "AI for Scientist"
```

### 2. Open in Xcode

```bash
open "AI for Scientist.xcodeproj"
```

### 3. Build and Run

1. Select your target device/simulator
2. Press `Cmd+R` to build and run
3. The app will launch with the home screen

## Configuration

### Claude Agents/Skills Integration

This app is designed to integrate with Claude agents for enhanced AI capabilities. To configure:

#### 1. Create Agent Configurations

Create the following directory structure:

```bash
mkdir -p .claude/agents .claude/commands .claude/skills
```

#### 2. Literature Search Agent

Create `.claude/agents/literature-search.json`:

```json
{
  "name": "literature-search",
  "description": "Search scientific literature using semantic understanding",
  "version": "1.0",
  "capabilities": [
    "semantic_search",
    "paper_ranking",
    "relevance_scoring"
  ],
  "config": {
    "model": "claude-sonnet-4-5",
    "max_results": 20,
    "min_relevance": 0.3
  }
}
```

#### 3. Newsletter Generator Agent

Create `.claude/agents/newsletter-generator.json`:

```json
{
  "name": "newsletter-generator",
  "description": "Generate customized research newsletters with summaries",
  "version": "1.0",
  "capabilities": [
    "text_generation",
    "summarization",
    "content_curation"
  ],
  "config": {
    "model": "claude-sonnet-4-5",
    "summary_style": "academic",
    "max_length": 2000
  }
}
```

#### 4. Example Skills

Create `.claude/skills/paper-analysis.json`:

```json
{
  "name": "paper-analysis",
  "description": "Analyze scientific papers and extract key information",
  "version": "1.0",
  "actions": [
    {
      "name": "extract_keywords",
      "description": "Extract important keywords from paper text"
    },
    {
      "name": "summarize_abstract",
      "description": "Generate concise summary of abstract"
    },
    {
      "name": "identify_methodology",
      "description": "Identify research methodology used"
    }
  ]
}
```

### Service Integration

The app currently uses placeholder implementations for AI agents. To enable full integration:

1. **LiteratureSearchService**: Update the `searchWithAIAgent()` method in `Services/LiteratureSearchService.swift`
2. **NewsletterService**: Update the `generateSummary()` method in `Services/NewsletterService.swift`

Example integration pattern:

```swift
// In LiteratureSearchService.swift
func searchWithAIAgent(query: String, context: String?) async throws -> [Paper] {
    // Load agent configuration
    let agentConfig = loadAgentConfig(AppConfig.literatureSearchAgent)

    // Prepare request
    let request = AgentRequest(
        agent: agentConfig,
        query: query,
        context: context
    )

    // Call agent API
    let response = try await agentAPI.execute(request)

    // Parse response into Paper objects
    return parsePapers(from: response)
}
```

## Usage Guide

### 1. Initial Setup

On first launch:
1. Select your research fields from the predefined list
2. Optionally upload your papers for personalized recommendations

### 2. Upload Papers

1. Navigate to the **Upload** tab
2. Tap "Upload PDF Paper"
3. Select a PDF from your device or iCloud
4. The app will automatically extract metadata
5. Use the uploaded paper to find related research

### 3. Generate Newsletter

1. Go to **Newsletters** tab and tap "+"
2. Select a research field
3. (Optional) Select one of your uploaded papers
4. Tap "Auto Search" or enter a custom AI search query
5. Review found papers
6. Tap "Generate Newsletter"
7. View and share your personalized newsletter

### 4. Manage Settings

In the **Settings** tab:
- Add/remove research fields
- Configure notification preferences
- View storage statistics
- Clear all data

## Development

### Running Tests

```bash
# Run all tests
xcodebuild test -project "AI for Scientist.xcodeproj" \
  -scheme "AI for Scientist" \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test suite
xcodebuild test -project "AI for Scientist.xcodeproj" \
  -scheme "AI for Scientist" \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:AI_for_ScientistTests/ModelTests

# Run single test
xcodebuild test -project "AI for Scientist.xcodeproj" \
  -scheme "AI for Scientist" \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:AI_for_ScientistTests/ModelTests/testPaperInitialization
```

### Project Structure

```
AI for Scientist/
│
├── AI for Scientist/           # Main application target
│   ├── Models/                 # Data models
│   │   ├── ResearchField.swift
│   │   ├── Paper.swift
│   │   ├── Newsletter.swift
│   │   └── UserProfile.swift
│   │
│   ├── Views/                  # SwiftUI views
│   │   ├── HomeView.swift
│   │   ├── FieldSelectionView.swift
│   │   ├── PDFUploadView.swift
│   │   ├── NewsletterGenerationView.swift
│   │   ├── NewsletterListView.swift
│   │   ├── NewsletterDetailView.swift
│   │   └── SettingsView.swift
│   │
│   ├── ViewModels/             # View models
│   │   ├── MainViewModel.swift
│   │   ├── PDFUploadViewModel.swift
│   │   ├── NewsletterGenerationViewModel.swift
│   │   └── NewsletterListViewModel.swift
│   │
│   ├── Services/               # Business logic services
│   │   ├── PDFService.swift
│   │   ├── LiteratureSearchService.swift
│   │   └── NewsletterService.swift
│   │
│   ├── Utils/                  # Utilities and extensions
│   │   └── Extensions.swift
│   │
│   ├── Config/                 # Configuration
│   │   └── AppConfig.swift
│   │
│   ├── Assets.xcassets/        # Images and colors
│   ├── AI_for_ScientistApp.swift  # App entry point
│   └── ContentView.swift       # Root view
│
├── AI for ScientistTests/      # Unit tests
│   ├── ModelTests.swift
│   ├── ServiceTests.swift
│   ├── ViewModelTests.swift
│   └── ExtensionTests.swift
│
├── AI for ScientistUITests/    # UI tests
│
├── .claude/                    # Claude agent configurations
│   ├── agents/
│   ├── commands/
│   └── skills/
│
├── README.md
└── CLAUDE.md                   # Claude Code guidance
```

### Adding New Features

#### Adding a New Research Field

Edit `Models/ResearchField.swift`:

```swift
static let predefinedFields: [ResearchField] = [
    // Existing fields...
    ResearchField(
        name: "Your Field",
        description: "Description",
        keywords: ["keyword1", "keyword2"]
    )
]
```

#### Adding a New Data Source

1. Create a new service in `Services/`
2. Implement search/fetch methods
3. Update `LiteratureSearchService` to use the new source
4. Add configuration in `Config/AppConfig.swift`

#### Customizing Newsletter Template

Edit the `generateHTMLContent()` method in `Models/Newsletter.swift`:

```swift
func generateHTMLContent() -> String {
    // Customize HTML template here
}
```

## API Reference

### arXiv API

The app uses the arXiv API for searching papers:
- Base URL: `https://export.arxiv.org/api/query`
- Documentation: https://arxiv.org/help/api

Example query:
```
https://export.arxiv.org/api/query?search_query=all:machine+learning&start=0&max_results=20
```

## Troubleshooting

### PDF Upload Issues

**Problem**: PDF fails to upload or parse
- Ensure PDF is text-based (not scanned images)
- Check file size (max 10MB)
- Verify PDF is not password-protected

### Search Not Working

**Problem**: No results from arXiv search
- Check internet connection
- Verify search keywords are relevant
- Try broader search terms
- Check arXiv API status

### Newsletter Generation Fails

**Problem**: Error during newsletter generation
- Ensure at least one paper in search results
- Check that research field is selected
- Verify sufficient storage space

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- arXiv for providing free access to scientific papers
- Anthropic Claude for AI capabilities
- SwiftUI for modern iOS development

## Contact

For questions or support:
- GitHub Issues: https://github.com/yourusername/ai-for-scientist/issues
- Email: your.email@example.com

## Roadmap

- [ ] Support for additional paper sources (PubMed, Google Scholar)
- [ ] PDF annotation and highlighting
- [ ] Collaborative features (share newsletters with colleagues)
- [ ] Export to reference managers (BibTeX, Zotero)
- [ ] Advanced search filters and sorting
- [ ] Dark mode theme
- [ ] iPad optimization with split view
- [ ] Watch app for quick paper bookmarking
