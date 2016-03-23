# fcrepo-event-ontology

An ontology for describing Fedora events.

## Namespace

The Fedora event ontology namespace is `http://fedora.info/definitions/v4/event#`.

## Classes

Each event will have one or more `rdf:type` values. These types include:

  * `event:ResourceCreation`
  * `event:ResourceDeletion`
  * `event:PropertyModification`

## Properties

Each event will contain the following data:

  * `event:repositoryRoot` - The location of the repository root.
  * `event:resourcePath` - The path of the resource.
  * `event:resourceType` - The `rdf:type` of the resource.
  * `event:timestamp` - The timestamp of the event.
  * `event:user` - The user on whose behalf the operation was issued.
  * `event:userAgent` - The userAgent information corresponding to the event.

## Example Event

A message serialized as JSON+LD could take the following form:

    {
      "@context" : "http://fedora.info/definitions/v4/event.json" ,
      "id" : "http://localhost:8080/fcrepo/rest/path/to/resource" ,
      "type" : [
            "http://fedora.info/definitions/v4/event#ResourceCreation" ,
            "http://fedora.info/definitions/v4/event#PropertyModification" ] ,
      "repositoryRoot" : "http://localhost:8080/fcrepo/rest" ,
      "resourcePath" : "/path/to/resource" ,
      "resourceType" : [
            "http://fedora.info/definitions/v4/repository#Resource" ,
            "http://fedora.info/definitions/v4/repository#Container" ] ,
      "timestamp" : 1458750952 ,
      "user" : "fedo raAdmin" ,
      "userAgent" : "CLAW client/1.0"
    }

