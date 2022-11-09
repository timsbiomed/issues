#!/usr/bin/env bash

# create ROOT.war
mvn clean install

# embed ROOT.war in spring-boot stuff, call that ROOT.war
mvn clean package spring-boot:repackage --Pboot && java -jar target/hapi-fhir-jpaserver.war

