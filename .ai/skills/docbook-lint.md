# Skill: DocBook & XML Progressive Linting

Use this skill to validate DocBook 5 structures and enforce indentation rules ONLY on lines modified in the current Git working tree relative to the base branch.

## Dependent Configuration
This skill relies on the following parameters defined in `./.ai/config.md`:
- `INDENT_SPACES`, `INDENT_CHAR`, `STRICT_DOCBOOK`, `BASE_REF`, `MAX_LINE_LENGTH`

---

## Technical Execution Pipeline

### Pass 1: Git Diff Tracking
1. Execute a Git diff comparison against the merge base of the configured `BASE_REF` (using the triple-dot `git diff -U0 BASE_REF...` strategy).
2. Isolate and map the exact 1-based line numbers that have been modified or newly added in this branch. 
3. Any line number *not* explicitly caught in this diff map MUST be treated as read-only for formatting and layout transformations.

### Pass 2: DocBook 5 Structural Alignment & Paragraph Enforcement
Before calculating indentation depths, evaluate the semantic structure of the document:
1. **DocBook 5 Schema Verification:** If `STRICT_DOCBOOK` is true, evaluate the document against DocBook 5 structural hierarchies. Identify any broken structural syntax or out-of-order parent/child element relationships.
2. **Paragraph Enforcement:** Scan for text blocks, tables, or itemized lists missing container elements. If an exposed or raw text node falls within or immediately adjacent to a modified line tracked in Pass 1, explicitly wrap it in properly closed `<para>...</para>` tags to ensure schema compliance.

### Pass 3: Global Ideal Depth Parsing
1. Scan and parse the entire XML document (including any newly injected `<para>` elements from Pass 2) to build a full structural tree.
2. Calculate the **absolute ideal indentation depth** for every single line based on its global tag hierarchy position—independent of how the current surrounding lines are actually indented.
3. **Protected Zone Flagging:** Identify any blocks enclosed within `<programlisting>...</programlisting>` tags. Add these line ranges to a protected set.

### Pass 4: Selective Target Enforcement
Reconstruct the file line-by-line using the following conditions:

- **Rule A (Protected/Unchanged Lines):** If a line is within the `<programlisting>` zone, OR its line number is absent from the Git Diff map, **do not touch it.** Retain its original layout, spacing, and characters byte-for-byte.
- **Rule B (Modified/Newly Added Lines):** If a line number is present in the Git Diff map, or was generated via Paragraph Enforcement:
  1. Retrieve its ideal structural depth calculated from Pass 3.
  2. Compute the exact required indentation prefix: `INDENT_CHAR` multiplied by (`INDENT_SPACES` * `depth`).
  3. Strip existing leading whitespace, apply the new calculated prefix, and wrap content gracefully if it exceeds `MAX_LINE_LENGTH`.

### Pass 5: Data Tracking Requirement
- When a structural schema validation error occurs or a missing `<para>` tag is injected, you SHALL record the exact `File` and the specific `Line` number where the structural modification took place.
- If an XML schema error spans a block, log the starting `Line` number.
