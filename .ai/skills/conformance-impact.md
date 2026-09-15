# Skill: Conformance & Profiles Impact Assessment

Use this skill during high-level release gates to analyze how specification modifications interact with ONVIF compliance testing systems.

## Dependent Configuration
This skill operates in conjunction with tracking parameters defined in:
- `./.ai/config.md`

---

## Instructions

### 1. Profile Dependency Checking
- Evaluate whether modified technical requirements intersect with features mandatory for defined ONVIF Profiles (e.g., Profile S, G, T, M, or newer profiles).
- If a modification relaxes a requirement or alters an interface tied directly to a Profile's mandatory feature set, you SHALL flag this impact explicitly to the user.

### 2. Testability Audits
- Audit new normative clauses to verify they describe verifiable, deterministic behavior. 
- If a modified clause introduces a requirement that cannot be programmatically verified by the ONVIF Device or Client Test Tools, flag it as an "untestable requirement assertion" so the committee can adjust the wording.

### 3. Data Tracking Requirement
- When a structural schema validation error occurs or a missing `<para>` tag is injected, you SHALL record the exact `File` and the specific `Line` number where the structural modification took place.
- If an XML schema error spans a block, log the starting `Line` number.
