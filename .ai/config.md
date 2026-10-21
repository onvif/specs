# Repository AI Configuration Variables

These variables define the global styling, formatting, and workspace parameters across all active AI skills. Modifying values here updates them globally.

## Code Formatting & Layout
- `INDENT_CHAR`: "space"        # Options: "space", "tab"
- `INDENT_SPACES`: 4            # Number of indent characters per level
- `MAX_LINE_LENGTH`: 120         # Maximum characters allowed per line

## File System & Encoding
- `ENFORCE_ENCODING`: "UTF-8"   # Forced file output encoding standard
- `LINE_ENDINGS`: "LF"          # Options: "LF", "CRLF"

## Git Control
- `BASE_REF`: "development"            # The base branch for targeted git diff evaluations

## Protocol Standards
- `STRICT_DOCBOOK`: true        # Toggle switch for strict DocBook 5 verification
