# Skill: Specification Proofreading & Linting

Use this skill to validate grammar, correct encoding artifacts, enforce DocBook 5 schemas, and standardize XML code blocks.

## Tunable Rules & Variables
*Manually adjust these variables to control formatting constraints:*
- `INDENT_SPACES`: 2
- `INDENT_CHAR`: "space"       # Options: "space", "tab"
- `ENFORCE_ENCODING`: "UTF-8"
- `LINE_ENDINGS`: "LF"         # Options: "LF", "CRLF"
- `STRICT_DOCBOOK`: true

---

## Core Constraints & Guardrails
> **CRITICAL:** You act strictly as a corrector and formatter. You are NEVER permitted to create new technical content, introduce new examples, or append unauthorized paragraphs. Only fix, format, and align what is already present in the source files.

---

## Technical Logic & Execution Passes

### Pass 1: Encoding & Text Normalization
- **Encoding Repair:** Read the file content and check for character corruption (mojibake). Identify and fix broken byte transitions (e.g., corrupt characters like `Ã©` or `` resulting from legacy copy-pastes) and convert them bak to their clean, intended characters in `ENFORCE_ENCODING`.
- **Line Endings:** Normalize all row endings across the document to match the `LINE_ENDINGS` variable uniformly.
- **Whitespace Cleanup:** Strip all trailing whitespaces at the end of lines and remove accidental double-blank lines.

### Pass 2: Prose & Grammar Proofreading
- **Spellcheck:** Automatically fix typos and misspelled technical terms.
- **Subject-Verb Coherence:** Ensure strict agreement in plurality/singularity. If a subject is singular, the verb must be singular; if plural, the verb must be plural.
- **Syntax & Punctuation:** Correct broken punctuation strings, missing periods at sentence ends, and basic grammatical mistakes.

### Pass 3: DocBook 5 Structural Alignment
- **Missing Elements:** Verify compliance with the DocBook 5 schema. 
- **Paragraph Enforcement:** Scan for text blocks, tables, or itemized lists missing container elements. Explicitly wrap exposed or raw text nodes into properly closed `<para>...</para>` tags where required by the schema.

### Pass 4: XML Structure & Indentation Enforcer
- **Syntax Evaluation:** Check the underlying validity of XML code blocks. Ensure all tags open and close properly, attributes are quoted correctly, and nesting is logically sound.
- **Hierarchical Indentation:** Re-indent the XML structure completely from scratch. Child nodes must be indented relative to their parent node by exactly one unit of `INDENT_SPACES`. 
- **No Mixing:** Do not mix tabs and spaces. Rely entirely on the character specified in `INDENT_CHAR`.
