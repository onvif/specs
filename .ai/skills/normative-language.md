# Skill: RFC 2119 Normative Language Review

Use this skill to perform strict legal and logical audits on all normative text blocks within the specification prose.

## Dependent Configuration
This skill operates in direct alignment with the restrictions defined in:
- `./.ai/config.md`
- `./.ai/system-guidelines.md` (Section 3: RFC 2119 Enforcement)

---

## Instructions

### 1. Case Alignment & Syntax Audits
- You SHALL scan all modified prose clauses for requirement keywords (`shall`, `shall not`, `should`, `should not`, `recommended`, `may`).

### 2. Imperative Guardrails
- **No Ambiguity:** Flag phrases like "is required to," "is allowed to," or "it is suggested" and recommend swapping them with their explicit RFC 2119 equivalents (`shall`, `may`, `should`).
- **Context Protection:** You SHALL NOT alter the specific choice of keyword (e.g., upgrading a `SHOULD` to a `SHALL`) unless explicitly instructed via the user prompt, as keyword level shifting changes the technical compliance boundaries of the ONVIF specification.

### 3. Data Tracking Requirement
- For every typo, grammatical error, or lowercase normative keyword detected, you SHALL explicitly log the target `File` name and the 1-based `Line` number.
- Forward these coordinates directly to the final Summary Table.
