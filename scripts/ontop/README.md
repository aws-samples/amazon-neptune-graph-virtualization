# Ontop Mapping: SPARQL/SQL for Temperature Readings

The file [climate.obda](climate.obda) mapping looks like this:

```
target		clmr:{timestamp}/{station} a clmo:TemperatureReading ; clmo:dateTime {date}^^xsd:dateTime ; clmo:fahrenheit {fahrenheit}^^xsd:float ; clmo:celsius {celsius}^^xsd:float ; clmo:station clmr:{station} . 
source		select * from "lenses"."climate"
```

Let's walk through this. Among the columns in the climate table in the data lake are the followinw:

- station
- timestamp
- date
- fahrenheit
- celsius

The mapping source selects all columns from rows in the table. For our target, we create RDF triples by substituting column values (wrapped in curly braces) from the source. 

An RDF triple is of the form subject-predicate-object. The mapping creates the following triples:

- clmr:{timestamp}/{station} a clmo:TemperatureReading. Here "a" is shortform for "rdf:type".
- clmr:{timestamp}/{station} clmo:dateTime {date}^^xsd:dateTime
- clmr:{timestamp}/{station} clmo:fahrenheit {fahrenheit}^^xsd:float
- clmr:{timestamp}/{station} clmo:celsius {celsius}^^xsd:float
- clmr:{timestamp}/{station} clmo:station clmr:{station}

Here clmr and clmo are prefixes that correspond to namespaces:

```
clmo:		http://climate.aws.com/ontology/
clmr:		http://climate.aws.com/resource#
```

Let's assume we get back the following column values for a specific row
- station: 6161099999
- timestamp: 480956400
- date: 1985-03-29T15:00:00
- fahrenheit: 95.72
- celsius: 35.4

The RDF triples are:

- clmr:480956400/6161099999 a clmo:TemperatureReading. Here "a" is shortform for "rdf:type".
- clmr:480956400/6161099999  clmo:dateTime 1985-03-29T15:00:00^^xsd:dateTime
- clmr:480956400/6161099999  clmo:fahrenheit 95.72^^xsd:float
- clmr:480956400/6161099999  clmo:celsius 35.4^^xsd:float
- clmr:480956400/6161099999  clmo:station clmr:6161099999

