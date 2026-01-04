# Generate Newsletter Command

This command generates a customized research newsletter.

## Usage

```
/generate-newsletter --field <field> [--paper <paper-id>] [--papers <paper-ids>]
```

## Parameters

- `--field` (required): Research field for the newsletter
- `--paper` (optional): ID of user's paper to base recommendations on
- `--papers` (optional): Comma-separated list of paper IDs to include

## Examples

```bash
# Generate newsletter for a field
/generate-newsletter --field "Artificial Intelligence"

# Generate based on user's paper
/generate-newsletter --field "Physics" --paper abc123

# Generate with specific papers
/generate-newsletter --field "Biology" --papers paper1,paper2,paper3
```

## Output

Returns a structured newsletter containing:
- Title
- Executive summary
- Curated papers organized by theme
- Key insights and trends
- Reading recommendations

## Integration

This command calls the `newsletter-generator` agent configured in `.claude/agents/newsletter-generator.json`.
