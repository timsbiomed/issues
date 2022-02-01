# Notes
# 1. Needed to change -f flag (copy pasted these commands from docs) to -v
#FILES_SNOMED=./data/value_sets/terminologies/SNOMED/SnomedCT_RF2Release_INT_20160131.zip  # docs had it named this
#FILES_SNOMED=./data/value_sets/terminologies/SNOMED/SnomedCT_RF2Release_US1000124_20160301.zip
FILES_SNOMED=./data/value_sets/terminologies/SNOMED/SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip
FILES_LOINC1=./data/value_sets/terminologies/LOINC/Loinc_2.71_MultiAxialHierarchy_3.5.zip

# TODO: LOINC Got err missing files:
# failed: expected file not found
#FILES_LOINC2=./data/value_sets/terminologies/LOINC/Loinc_2.71_Text_2.71.zip
# failed: expected file not found
#FILES_LOINC2=./data/value_sets/terminologies/LOINC/LoincTableCore.csv
# failed: unrecognized file
FILES_LOINC2=/Users/joeflack4/projects/hapi-fhir-jpaserver-starter/data/value_sets/terminologies/LOINC/_archive/_Full/Loinc_2.71.zip

FILES_ICD10CM=./data/value_sets/terminologies/ICD-10-CM/icd10cm_tabular_2021.xml
# Docs (https://hapifhir.io/hapi-fhir/docs/tools/hapi_fhir_cli.html) expec tthis:
# UPLOAD_ENDPOINT=http://localhost:8080/baseDstu3
# HAPI FHIR starter has this base endpoint, but doesn't work for upload:
UPLOAD_ENDPOINT=http://localhost:8080/fhir
# Docs said dstu3, but I think have r4
#FHIR_VERSION=dstu3
FHIR_VERSION=r4


.PHONY: deploy upload-terminology upload-snomed upload-loinc upload-icd10cm


deploy:
	mvn clean install; \
	docker-compose up -d --build

upload-terminology: upload-snomed upload-loinc upload-icd10cm

upload-snomed:
	hapi-fhir-cli upload-terminology -d ${FILES_SNOMED} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u http://snomed.info/sct

upload-loinc:
	hapi-fhir-cli upload-terminology -d ${FILES_LOINC1} -d ${FILES_LOINC2} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u http://loinc.org

upload-icd10cm:
	hapi-fhir-cli upload-terminology -d ${FILES_LOINC1} -d ${FILES_ICD10CM} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u http://hl7.org/fhir/sid/icd-10-cm
