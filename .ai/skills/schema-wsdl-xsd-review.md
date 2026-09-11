# Skill: WSDL & XSD Schema Contract Review

Use this skill to audit, syntax-check, and format raw XML Schema Definitions (XSD) and Web Services Description Language (WSDL) structures.

## Dependent Configuration
This skill inherits layout and targeting parameters directly from `./.ai/config.md`:
- `INDENT_CHAR`, `INDENT_SPACES`, `MAX_LINE_LENGTH`, `BASE_REF`

---

## Instructions

### 1. ONVIF Structural Contract Audits
- Verify that all newly introduced or modified namespaces strictly adhere to official ONVIF naming conventions and URL structures.
- Ensure all custom complexTypes, simpleTypes, and element declarations are explicitly typed and cleanly bounded.

### 2. Targeted XML Contract Formatting
- For any XSD or WSDL blocks modified relative to `BASE_REF`, you SHALL enforce the exact formatting metrics specified in the configuration file.
- Re-indent lines using the `INDENT_CHAR` and `INDENT_SPACES` configurations. Strip out trailing whitespaces and ensure lines wrap neatly before hitting the `MAX_LINE_LENGTH` threshold.
