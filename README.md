# fcrepo-event-ontology

An ontology for describing Fedora events.

## Namespace

The Fedora event ontology namespace is `http://fedora.info/definitions/v4/event#`.

## Classes

Each event will be described with one or more `rdf:type` values from the Fedora event
ontology. These types include:

  * `event:ResourceCreation`
  * `event:ResourceDeletion`
  * `event:ResourceModification`
  * `event:ResourceRelocation`

## Application profile for Fedora events (proof-of-concept)

This ontology is only one part of a larger application profile for describing Fedora events.
That application profile is still a work in progress and is dependent on a finalization of
the Fedora Messaging SPI specification.

### Data described in events

According to the draft Fedora SPI specification, each event must contain the following data:

  * The URL of the affected resource
  * The dateTime of the resource modification
  * The `rdf:type` of the affected resource
  * A unique identifier for the event
  * The type of repository event (e.g. `event:ResourceModification`)

In addition, these properties are optional:

  * The location of the repository (e.g. the root of the repository)
  * The resource path (i.e. the URL with the repository root removed)
  * The user(s) on whose behalf the resource was changed
  * The software agent(s) used to modify the resource

### Using PROV to describe events

In this proof of concept, Fedora events are described using the [PROV ontology](https://www.w3.org/TR/prov-o/)
along with some other commonly used ontologies (`foaf`, `dcterms`).

#### RDF structure (TTL)

A message could be described in RDF like so:

    @prefix prov: <http://www.w3.org/ns/prov#> .
    @prefix dcterms: <http://purl.org/dc/terms/> .
    @prefix foaf: <http://xmlns.com/foaf/0.1/> .
    @prefix event: <http://fedora.info/definitions/v4/event#> .
    @prefix fedora: <http://fedora.info/definitions/v4/repository#> .
    @prefix ex: <http://example.org/> .
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

    <http://localhost:8080/fcrepo/rest/path/to/resource> a ex:CustomType,
          fedora:Container, fedora:Resource, prov:Entity;
      prov:wasAttributedTo [ a prov:Person; foaf:name "fedo raAdmin"],
          [ a prov:SoftwareAgent; foaf:name "CLAW client/1.0"];
      prov:wasGeneratedBy [
          a event:ResourceCreation, prov:Activity;
          prov:atTime "2016-05-19T17:17:39-04:00Z"^^xsd:dateTime;
          dcterms:identifier <urn:uuid:3c834a8f-5638-4412-aa4b-35ea80416a18> ];
      dcterms:isPartOf <http://localhost:8080/fcrepo/rest> .

#### Example Event (JSON-LD)

In a messaging system, it would be more common that a message would be serialized as compact JSON-LD.
A compact JSON-LD serialization could, therefore, take the following form:

    {
      "@context" : "http://fedora.info/definitions/v4/event.json" ,
      "id" : "http://localhost:8080/fcrepo/rest/path/to/resource" ,
      "type" : [
        "http://www.w3.org/ns/prov#Entity" ,
        "http://fedora.info/definitions/v4/repository#Resource" ,
        "http://fedora.info/definitions/v4/repository#Container" ,
        "http://example.org/CustomType" ] ,
      "isPartOf" : "http://localhost:8080/fcrepo/rest" ,
      "wasGeneratedBy" : {
        "type" : [
          "http://www.w3.org/ns/prov#Activity" ,
          "http://fedora.info/definitions/v4/event#ResourceCreation" ] ,
        "identifier" : "urn:uuid:3c834a8f-5638-4412-aa4b-35ea80416a18" ,
        "atTime" : "2016-05-19T17:17:39-04:00Z" } ,
      "wasAttributedTo" : [
        { "type" : "http://www.w3.org/ns/prov#Person" ,
          "name" : "fedo raAdmin" },
        { "type" : "http://www.w3.org/ns/prov#SoftwareAgent" ,
          "name" : "CLAW client/1.0" } ]
    }

Or, with the `@context` included inline:

    {
      "@context" : {
        "xsd" : "http://www.w3.org/2001/XMLSchema#" ,
        "type" : "@type" ,
        "id" : "@id" ,

        "atTime" : { "@id" : "http://www.w3.org/ns/prov#atTime", "@type" : "xsd:dateTime" } ,
        "identifier" : { "@id" : "http://purl.org/dc/terms/identifier" , "@type" : "@id" } ,
        "isPartOf" : { "@id" : "http://purl.org/dc/terms/isPartOf", "@type" : "@id" } ,
        "name" : { "@id" : "http://xmlns.com/foaf/0.1/name" } ,
        "wasAttributedTo" : { "@id" : "http://www.w3.org/ns/prov#wasAttributedTo", "@type" : "@id" } ,
        "wasGeneratedBy" : { "@id" : "http://www.w3.org/ns/prov#wasGeneratedBy", "@type" : "@id" }
      } ,

      "id" : "http://localhost:8080/fcrepo/rest/path/to/resource" ,
      "type" : [
        "http://www.w3.org/ns/prov#Entity" ,
        "http://fedora.info/definitions/v4/repository#Resource" ,
        "http://fedora.info/definitions/v4/repository#Container" ,
        "http://example.org/CustomType" ] ,
      "isPartOf" : "http://localhost:8080/fcrepo/rest" ,
      "wasGeneratedBy" : {
        "type" : [
          "http://www.w3.org/ns/prov#Activity" ,
          "http://fedora.info/definitions/v4/event#ResourceCreation" ] ,
        "identifier" : "urn:uuid:3c834a8f-5638-4412-aa4b-35ea80416a18" ,
        "atTime" : "2016-05-19T17:17:39-04:00Z" } ,
      "wasAttributedTo" : [
        { "type" : "http://www.w3.org/ns/prov#Person" ,
          "name" : "fedo raAdmin" },
        { "type" : "http://www.w3.org/ns/prov#SoftwareAgent" ,
          "name" : "CLAW client/1.0" } ]
    }

