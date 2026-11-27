"""Focused schema and JSON-LD checks for the first GeoSPARQL location binding."""

import copy
import json
from pathlib import Path
import unittest
import xml.etree.ElementTree as ET

from jsonschema import Draft202012Validator
from linkml.generators.jsonschemagen import JsonSchemaGenerator
from pyld import jsonld


FIXTURES = Path(__file__).parent / "fixtures"
GEO = "http://www.opengis.net/ont/geosparql#"
ONVIF = "https://www.onvif.org/ver10/agentic/linkml/"
BASE = "https://www.onvif.org/ver10/agentic/id/"


class GeoSPARQLBindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        generated = json.loads(
            JsonSchemaGenerator(str(FIXTURES / "spatial-examples.yaml")).serialize()
        )
        cls.schema = {"$defs": generated["$defs"], "$ref": "#/$defs/InformationEnvelope"}
        Draft202012Validator.check_schema(cls.schema)
        cls.validator = Draft202012Validator(cls.schema)
        cls.point = json.loads((FIXTURES / "point-envelope.json").read_text())
        cls.entrance = json.loads((FIXTURES / "entrance-envelope.json").read_text())

    def assert_valid(self, envelope):
        errors = list(self.validator.iter_errors(envelope))
        self.assertFalse(errors, "\n".join(error.message for error in errors))

    def test_complete_point_and_entrance_envelopes(self):
        for example in (self.point, self.entrance):
            with self.subTest(id=example["id"]):
                self.assert_valid(example)

    def test_geometry_associations_accept_objects_and_uuid_references(self):
        geometry = self.entrance["items"][0]["observedSpace"]["geometry"][0]
        for field in ("geometry", "defaultGeometry", "boundingBox", "centroid"):
            example = copy.deepcopy(self.entrance)
            feature = example["items"][0]["observedSpace"]
            feature[field] = [copy.deepcopy(geometry), geometry["id"]]
            with self.subTest(field=field):
                self.assert_valid(example)

    def test_embedded_geometry_requires_id(self):
        example = copy.deepcopy(self.entrance)
        del example["items"][0]["observedSpace"]["geometry"][0]["id"]
        self.assertFalse(self.validator.is_valid(example))

    def test_wrong_embedded_target_type_is_rejected(self):
        example = copy.deepcopy(self.entrance)
        example["items"][0]["observedSpace"]["geometry"] = [
            {"@type": "geo:Feature", "id": "12345678-1234-1234-1234-123456789ab8"}
        ]
        self.assertFalse(self.validator.is_valid(example))

    def test_malformed_geometry_reference_is_rejected(self):
        example = copy.deepcopy(self.entrance)
        example["items"][0]["observedSpace"]["geometry"] = ["not-a-uuid"]
        self.assertFalse(self.validator.is_valid(example))

    def test_scalar_properties_reject_arrays(self):
        values = {
            "dimension": [0, 3], "coordinateDimension": [2, 3],
            "spatialDimension": [2, 3], "empty": [True, False],
            "simple": [True, False], "metricSpatialAccuracy": [1.0, 2.0],
            "metricSpatialResolution": [1.0, 2.0],
        }
        for name, value in values.items():
            example = copy.deepcopy(self.point)
            example["items"][0]["observedSpace"][name] = value
            with self.subTest(field=name):
                self.assertFalse(self.validator.is_valid(example))

    def test_negative_dimension_and_metric_accuracy_are_rejected(self):
        for name in ("dimension", "coordinateDimension", "spatialDimension",
                     "metricSpatialAccuracy", "metricSpatialResolution"):
            example = copy.deepcopy(self.point)
            example["items"][0]["observedSpace"][name] = -1
            with self.subTest(field=name):
                self.assertFalse(self.validator.is_valid(example))

    def test_multiple_serializations_require_separate_geometries(self):
        example = copy.deepcopy(self.point)
        geometry = example["items"][0]["observedSpace"]
        geometry["asGeoJSON"].append({"type": "Point", "coordinates": [-99.12, 19.44]})
        self.assertFalse(self.validator.is_valid(example))

    def test_geojson_foreign_members_are_preserved(self):
        example = copy.deepcopy(self.point)
        geometry = example["items"][0]["observedSpace"]
        geometry["asGeoJSON"][0]["vendor:quality"] = {"value": 0.9}
        self.assert_valid(example)
        expanded = jsonld.expand(example)
        spatial = expanded[0][ONVIF + "items"][0][ONVIF + "observedSpace"][0]
        literal = spatial[ONVIF + "asGeoJSON"][0]
        self.assertEqual(literal["@type"], "@json")
        self.assertEqual(literal["@value"], geometry["asGeoJSON"])

    def test_embedded_geometry_expands_to_an_identified_node(self):
        expanded = jsonld.expand(self.entrance)
        feature = expanded[0][ONVIF + "items"][0][ONVIF + "observedSpace"][0]
        geometry = feature[GEO + "hasGeometry"][0]
        self.assertEqual(geometry["@type"], [GEO + "Geometry"])
        self.assertEqual(geometry["@id"], BASE +
                         self.entrance["items"][0]["observedSpace"]["geometry"][0]["id"])
        self.assertEqual(feature["http://www.w3.org/2000/01/rdf-schema#label"][0]["@value"],
                         "Main entrance")
        self.assertEqual(geometry[GEO + "dimension"][0]["@type"],
                         "http://www.w3.org/2001/XMLSchema#integer")

    def test_uuid_reference_expands_to_the_same_node_identifier(self):
        example = copy.deepcopy(self.entrance)
        feature = example["items"][0]["observedSpace"]
        identifier = feature["geometry"][0]["id"]
        feature["centroid"] = [identifier]
        expanded = jsonld.expand(example)
        spatial = expanded[0][ONVIF + "items"][0][ONVIF + "observedSpace"][0]
        self.assertEqual(spatial[GEO + "hasCentroid"][0]["@id"],
                         spatial[GEO + "hasGeometry"][0]["@id"])

    def test_reference_resolution_is_not_a_local_schema_check(self):
        example = copy.deepcopy(self.entrance)
        example["items"][0]["observedSpace"]["geometry"] = [
            "12345678-1234-1234-1234-123456789ab8"
        ]
        self.assert_valid(example)
        # No target is supplied: a consumer must report this as unresolved,
        # rather than treating successful local validation as resolution.

    def test_specification_fragment_preserves_embedded_geometry_and_dimensions(self):
        document = ET.parse(FIXTURES.parents[2] / "doc" / "Agentic.xml")
        section = next(node for node in document.iter()
                       if node.get("{http://www.w3.org/XML/1998/namespace}id")
                       == "sec_geosparql_location")
        listing = next(node for node in section.iter()
                       if node.tag.rsplit("}", 1)[-1] == "programlisting")
        fragment = json.loads(listing.text)
        feature = jsonld.expand(fragment)[0]
        geometry = feature[GEO + "hasGeometry"][0]
        self.assertEqual(geometry[GEO + "dimension"][0]["@value"], 2)
        self.assertEqual(geometry[GEO + "coordinateDimension"][0]["@value"], 2)
        self.assertEqual(geometry[ONVIF + "asGeoJSON"][0]["@type"], "@json")

    def test_geojson_content_requires_a_separate_validator(self):
        example = copy.deepcopy(self.point)
        example["items"][0]["observedSpace"]["asGeoJSON"] = [42]
        # Deliberately unconstrained LinkML wildcard; this is NOT conformant GeoJSON.
        self.assert_valid(example)


if __name__ == "__main__":
    unittest.main()
