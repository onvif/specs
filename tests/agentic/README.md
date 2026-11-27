# GeoSPARQL location examples and checks

Run from the repository root:

```sh
python -m pip install -r tests/agentic/requirements.txt
python -m unittest discover -s tests/agentic -p 'test_*.py' -v
```

The fixtures contain complete unsigned InformationEnvelopes: one geographic point
and one named entrance with its geographic polygon embedded. No geometry lookup is
needed. The example module specializes Observation only to make these fixtures
executable; it is not part of the normative ONVIF schema bundle. Its result and
provenance reuse the existing illustrative hackathon module.

Checks compile the complete module closure with LinkML 1.12.1, validate payloads
with JSON Schema, and expand JSON-LD with PyLD. They cover embedded geometry and
UUID alternatives, target types for embedded objects, mandatory identifiers,
single-valued properties, numeric bounds, the serialization cardinality, foreign
members, label mapping, numeric datatypes and stable node references.

These checks are not a GeoSPARQL conformance suite or a complete RFC 7946 validator.
In particular, JSON Schema still accepts malformed GeoJSON content and syntactically
valid unresolved UUIDs. The tests explicitly demonstrate these boundaries.

Additional consumer acceptance cases, enforced outside the generated JSON Schema:

| Input | Expected outcome |
| --- | --- |
| Geometry reference whose definition is unavailable | Report unresolved; do not calculate with it |
| Geometry UUID resolving to a Feature | Reject the target type |
| Same geometry UUID with different coordinate definitions | Report a conflicting definition; do not overwrite |
| dimension greater than spatialDimension or spatialDimension greater than coordinateDimension | Reject inconsistent dimensions |
| Invalid GeoJSON geometry type, malformed coordinates or unclosed polygon ring | Reject through RFC 7946 validation |
| Valid signature over a citing item without origin protection for a separately supplied target | Do not infer target-origin verification |

The fixtures are unsigned. Cryptographic verification, immutable-definition history,
reference resolution and complete GeoJSON validation are not implemented or claimed
by this focused test suite.
