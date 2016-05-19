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

## Properties

Each event must also indicate the root location of the repository in which
the resource is contained. For that purpose, this property is provided:
`event:containedInRepository`.

## Data described in events

Each event will contain the following required data:

  * The URL of the affected resource
  * The dateTime of the resource modification
  * The `rdf:type` of the affected resource
  * A unique identifier for the event
  * The type of repository event (e.g. `event:ResourceModification`)

In addition, these optional properties may be available:

  * The location of the repository (e.g. the root of the repository)
  * The resource path (i.e. the URL with the repository root removed)
  * The user(s) on whose behalf the resource was changed
  * The software agent(s) used to modify the resource

In this proof of concept, these events are described using the [PROV ontology](https://www.w3.org/TR/prov-o/)
along with some other commonly used ontologies (`foaf`, `dc`).

## Example Event

A message serialized as compact JSON+LD could, therefore, take the following form:

    {
      "@context" : "http://fedora.info/definitions/v4/event.json" ,
      "id" : "http://localhost:8080/fcrepo/rest/path/to/resource" ,
      "type" : [
        "Entity" ,
        "Resource" ,
        "Container" ,
        "http://example.org/CustomType" ] ,
      "identifier" : "/path/to/resource" ,
      "containedInRepository" : "http://localhost:8080/fcrepo/rest" ,
      "wasGeneratedBy" : {
        "type" : [
          "Activity" ,
          "ResourceCreation" ] ,
        "identifier" : "3c834a8f-5638-4412-aa4b-35ea80416a18" ,
        "atTime" : "2016-05-19T17:17:39-04:00" } ,
      "wasAttributedTo" : [
        { "type" : "Person" ,
          "name" : "fedo raAdmin" },
        { "type" : "SoftwareAgent" ,
          "name" : "CLAW client/1.0" } ]
    }

