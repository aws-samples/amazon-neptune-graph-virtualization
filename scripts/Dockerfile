FROM ontop/ontop-endpoint
WORKDIR /opt/ontop
COPY ontop/lake.ttl ontop/lake.obda ontop/lake.properties input/ 
COPY  jdbc/AthenaJDBC42-2.0.33.jar jdbc/
EXPOSE 8080
ENTRYPOINT java -cp ./lib/*:./jdbc/* -Dlogback.configurationFile=file:./log/logback.xml \
        it.unibz.inf.ontop.cli.Ontop endpoint \
        --ontology=input/lake.ttl \
        --mapping=input/lake.obda \
        --properties=input/lake.properties \
        --cors-allowed-origins=* \
        --lazy # if needed


        