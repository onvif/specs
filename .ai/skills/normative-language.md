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
- If any requirement keyword is found in lowercase or mixed-case within a normative requirement context, you SHALL convert it to strict **UPPERCASE** (e.g., changing "the device shall" to "the device SHALL").

### 2. Imperative Guardrails
- **No Ambiguity:** Flag phrases like "is required to," "is allowed to," or "it is suggested" and recommend swapping them with their explicit RFC 2119 uppercase equivalents (`SHALL`, `MAY`, `SHOULD`).
- **Context Protection:** You SHALL NOT alter the specific choice of keyword (e.g., upgrading a `SHOULD` to a `SHALL`) unless explicitly instructed via the user prompt, as keyword level shifting changes the technical compliance boundaries of the ONVIF specification.
