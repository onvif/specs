# Skill: Technical Proofreading & Text Hygiene

Use this skill to handle structural grammar normalization, character conversions, and basic row hygiene parameters.

## Dependent Configuration
This skill relies on the following parameters defined in `./.ai/config.md`:
- `ENFORCE_ENCODING`, `LINE_ENDINGS`

---

## Instructions

### 1. Encoding Repair
- Scan the document for broken byte transitions or character corruptions (mojibake artifacts such as `Ã©` resulting from legacy copy-pastes). 
- Repair these characters to their true clean intended counterparts and force file writing output to strictly comply with `ENFORCE_ENCODING`.

### 2. Grammar & Coherence
- Check for absolute subject-verb plurality/singularity agreement within specification clauses. 
- Automatically fix obvious typos, dropped characters, and structural spelling mistakes in technical prose.

### 3. Whitespace Cleaning
- Normalize all row endings across the document to match the target environment variable `LINE_ENDINGS` uniformly.
- Strip trailing whitespaces at the terminal end of lines.

### 4. Data Tracking Requirement
- For every typo, grammatical error, or lowercase normative keyword detected, you SHALL explicitly log the target `File` name and the 1-based `Line` number.
- Forward these coordinates directly to the final Summary Table.
