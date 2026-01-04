# Search Papers Command

This command performs an AI-powered search for scientific papers.

## Usage

```
/search-papers <query> [--field <field>] [--max-results <n>]
```

## Parameters

- `query` (required): Search query or research topic
- `--field` (optional): Specific research field to search within
- `--max-results` (optional): Maximum number of results (default: 20)

## Examples

```bash
# Basic search
/search-papers machine learning applications in healthcare

# Search within specific field
/search-papers quantum computing --field Physics

# Limit results
/search-papers neural networks --max-results 10
```

## Output

Returns a list of relevant papers with:
- Title
- Authors
- Abstract
- Publication date
- arXiv ID
- Relevance score

## Integration

This command calls the `literature-search` agent configured in `.claude/agents/literature-search.json`.
