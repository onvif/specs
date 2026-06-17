# ONVIF Release Review Skill

Review ONVIF specification release candidates using source-first verification.

## Release naming and branch resolution

When the user refers to a release such as “26.06 RC2”, resolve it using the following order:

1. Try exact branch names:
   - `release/26.06rc2`
   - `release/26.06-rc2`
   - `26.06rc2`
   - `26.06-rc2`

2. Search branches containing:
   - `26.06`
   - `rc2`
   - `2606`

3. Search recent commits with release-related messages, for example:
   - `RC2`
   - `26.06`
   - `feedback from review of 26.06 RC1`
   - `Spellcheck`
   - `Additional feedback`
   - `Grammar fixes`

4. If no exact RC branch is found, use the latest commit in the visible RC commit sequence and clearly state:
   - exact commit hash
   - commit message
   - that no literal RC branch was resolved

5. Never silently assume that `main`, `develop`, or `master` is the RC branch.

## ONVIF release notation

Interpret ONVIF release notation as follows:

- `26.06` means the June 2026 ONVIF release.
- `26.12` means the December 2026 ONVIF release.
- `RC1`, `RC2`, etc. mean release-candidate iterations.
- A user phrase such as “26.06 RC2” should be mapped to likely GitHub refs such as `release/26.06rc2`, but the exact branch or commit must always be verified.

## Rules

Do:

- Resolve and record the exact GitHub branch or commit.
- Compare the candidate release against the previous RC/release.
- Identify relevant merged and open PRs.
- Verify whether PR effects are present in the candidate source.
- Review only concrete typos, errors, broken links, invalid references, malformed XML/DocBook, namespace errors, wrong dates, and visible rendering defects.
- Tie every finding to the exact file and section.
- Provide suggested replacement text or patch.
- Separate PR application status from remaining typo/error findings.

Do not:

- Comment on awkward wording.
- Comment on subjective style.
- Report PDF text-extraction artefacts.
- Report draft watermark issues.
- Suggest document-wide replacements unless explicitly required.
- Treat unresolved design discussions as editorial errors.
- Treat a merged PR as applied without checking the relevant source content.
- Treat an open PR as release-blocking unless it is clearly intended for the reviewed release.

## Output

1. Release target and commit hash.
2. PR application status.
3. Open/unapplied relevant PRs.
4. Concrete remaining typos/errors.
5. Suggested patches or replacement text.
6. Items intentionally not raised.
7. If requested, generate a PDF report with the same structure.
