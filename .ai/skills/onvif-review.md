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
Upon activation, you SHALL explicitly state which workflow you are engaging and list the sub-skills being initialized. Execute their rulesets sequentially, focusing audits on changes relative to `BASE_REF`.
