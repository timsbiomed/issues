# Notes
# 1. Needed to change -f flag (copy pasted these commands from docs) to -v
FILES_CUSTOM1="/Users/joeflack4/projects/hapi-fhir-jpaserver-starter/data/custom1/custom1.zip"
# docs had it named this:
#FILES_SNOMED="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/SNOMED/ZIP (Official - directly sourced)/SnomedCT_RF2Release_INT_20160131.zip"
#FILES_SNOMED="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/SNOMED/ZIP (Official - directly sourced)/SnomedCT_RF2Release_US1000124_20160301.zip"
FILES_SNOMED="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/SNOMED/ZIP (Official - directly sourced)/SnomedCT_USEditionRF2_PRODUCTION_20210901T120000Z.zip"

FILES_LOINC1="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/LOINC/ZIP (Official - directly sourced)/Loinc_2.71_MultiAxialHierarchy_3.5.zip"
# TODO: LOINC Got err missing files:
# failed: expected file not found
# - Note: Am I missing this? Do I need this? It gave me "failed: unrecognized file" anyway: Loinc_2.71.zip
# failed: expected file not found
#FILES_LOINC2="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/LOINC/ZIP (Official - directly sourced)/LoincTableCore.csv"
#FILES_LOINC2="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/LOINC/ZIP (Official - directly sourced)/Loinc_2.71_Text_2.71.zip"
FILES_LOINC2="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/LOINC/ZIP (Official - directly sourced)/Loinc_2.72.zip"

FILES_ICD10CM="/Users/joeflack4/LocalStorage/Work/BIDS/data_sources/vocabularies/byCodeSystem/ICD-10-CM/XML (Official - Sourced directly)/icd10cm_tabular_2022.xml"

# Docs (https://hapifhir.io/hapi-fhir/docs/tools/hapi_fhir_cli.html) expect this:
# UPLOAD_ENDPOINT=http://localhost:8080/baseDstu3x
# HAPI FHIR starter has this base endpoint, but doesn't work for upload:
# Edit joe 2022/02/16: Did below really not work? I know I was successfully able to upload something to localhost.
# Local server
# UPLOAD_ENDPOINT=http://localhost:8080/fhir
# Joe's server
UPLOAD_ENDPOINT=http://20.119.216.32:8080/fhir
# Peter's server
# UPLOAD_ENDPOINT=http://20.119.216.32:8888/pheno1r4/fhir
# Shahim's server (http://20.119.216.32:8888/ts1/fhir). Creds:
# - writer:writer
# - reader:reader
# UPLOAD_ENDPOINT=http://20.119.216.32:8888/ts1/fhir

# LOGIN: Use this when working w/ Shahim's server
# - Shahim's server
#LOGIN=-b PROMPT
# LOGIN=-b writer:writer
# - When login not required
LOGIN=

# Docs said dstu3, but I think have r4
#FHIR_VERSION=dstu3
FHIR_VERSION=r4


.PHONY: deploy upload-terminology upload-snomed upload-loinc upload-icd10cm


deploy:
	mvn clean install; \
	docker-compose up -d --build

upload-terminology: upload-snomed upload-loinc upload-icd10cm

upload-snomed:
	hapi-fhir-cli upload-terminology -d ${FILES_SNOMED} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u http://snomed.info/sct ${LOGIN}

# Note: (i) The one w/ 2 files is how it was written in the docs. (ii) The one with 1 file worked for Shahim.
#upload-loinc:
#	hapi-fhir-cli upload-terminology -d ${FILES_LOINC1} -d ${FILES_LOINC2} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u http://loinc.org ${LOGIN}
upload-loinc:
	hapi-fhir-cli upload-terminology -d ${FILES_LOINC2} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u http://loinc.org ${LOGIN}

upload-icd10cm:
	hapi-fhir-cli upload-terminology -d ${FILES_LOINC1} -d ${FILES_ICD10CM} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u http://hl7.org/fhir/sid/icd-10-cm ${LOGIN}

# Worked
upload-custom1:
	hapi-fhir-cli upload-terminology -d ${FILES_CUSTOM1} -v ${FHIR_VERSION} -t ${UPLOAD_ENDPOINT} -u ${UPLOAD_ENDPOINT}/CodeSystem/2

# Did't work
upload-custom1-curl:
	curl -X POST -H "Content-Type: application/json" -d @data/custom1/params.json "${UPLOAD_ENDPOINT}/CodeSystem/$upload-external-codesystem"
