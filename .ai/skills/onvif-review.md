# Skill: ONVIF Main Review Orchestrator

Use this skill to determine the scope of a task based on the requested workflow. You SHALL dynamically chain the relevant sub-skills located in this directory.

## Dependent Configuration
This skill relies on the following parameters defined in `./.ai/config.md`:
- `BASE_REF`

---

## Tunable Workflow Mappings
Analyze the user prompt or Git execution state to isolate the intent, then execute only the sub-skills mapped to that specific workflow sequence:

- **Workflow: Editorial Cleanup**
  - Load and execute: `proofreading.md`
  - Load and execute: `docbook-lint.md`

- **Workflow: PR Review**
  - Load and execute: `proofreading.md`
  - Load and execute: `docbook-lint.md`
  - Load and execute: `normative-language.md`
  - Load and execute: `schema-wsdl-xsd-review.md`

- **Workflow: Release Review**
  - Load and execute: `normative-language.md`
  - Load and execute: `backward-compatibility.md`
  - Load and execute: `conformance-impact.md`

---

## Execution Mandate
1. Upon activation, you SHALL explicitly state which workflow you are engaging and list the sub-skills being initialized.
2. Execute their rulesets sequentially, focusing audits on changes relative to `BASE_REF`.
3. **Final Aggregation:** You SHALL compile the individual logs from every executed sub-skill and output them in the unified markdown **Summary Table** defined in Section 5 of `system-guidelines.md`. Ensure that the `File` and `Line` numbers are captured accurately for every row.
