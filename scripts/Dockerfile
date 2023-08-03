FROM ontop/ontop
WORKDIR /opt/ontop
COPY ontop/climate.owl ontop/climate.obda ontop/climate.properties input/ 
COPY jdbc/AthenaJDBC42-2.1.0.1000.jar jdbc/
EXPOSE 8080
ENTRYPOINT java -cp ./lib/*:./jdbc/* -Dlogback.configurationFile=file:./log/logback.xml \
        it.unibz.inf.ontop.cli.Ontop endpoint \
        --ontology=input/climate.owl \
        --mapping=input/climate.obda \
        --properties=input/climate.properties \
        --cors-allowed-origins=* \
        --lazy # if needed
