# Skill: Release-to-Release Backward Compatibility

Use this skill during PR and Release reviews to safeguard existing client and device implementations against breaking changes.

## Dependent Configuration
This skill relies on the following parameters defined in `./.ai/config.md`:
- `BASE_REF`

---

## Instructions

### 1. Breaking Change Detection
Compare modifications against the schema and operation states present in `BASE_REF`. You SHALL immediately trigger a high-severity warning if the changes introduce any of the following breaking actions:
- Deleting, renaming, or re-ordering existing operations or messages in a service contract.
- Changing an optional request parameter into a mandatory parameter.
- Modifying existing data types or structural namespaces.
- Removing or changing the behavior of an existing, active enumeration value.

### 2. Deprecation Governance
- Verify that features targeted for phase-out are structurally marked with explicit deprecation annotations within the documentation prose rather than undergoing sudden removal.
