" Creating the Service Consumption Model
" https://github.com/SAP-samples/abap-platform-rap-opensap/blob/main/week5/unit2.md

" Implement a Custom Entity and API Execution (Query Implementation) Class
" https://developers.sap.com/tutorials/abap-environment-a4c-create-custom-entity.html

" Get a user in api.sap.com.
" Download the $metadata file of the OData service we want to consume from this page: https://api.sap.com/api/API_BUSINESS_PARTNER/overview
" Create Service Consumption Model with the name Z**_SC_BUSINESS_PARTNER using the downloaded metadata file (the entity set “A_BUSINESS_PARTNER” needs to be retrieved).

CONSTANTS sc_service_url    TYPE string VALUE 'https://sandbox.api.sap.com/s4hanacloud'     ##NO_TEXT.
CONSTANTS sc_service_root   TYPE string VALUE '/sap/opu/odata/sap/API_BUSINESS_PARTNER/'    ##NO_TEXT.
CONSTANTS sc_proxy_model_id TYPE string VALUE 'ZRP_SC_BUSINESS_PARTNER_A2X'                 ##NO_TEXT.
CONSTANTS sc_apikey         TYPE string VALUE `NmVVejJNOUlISUxQNGZ6OWxKYXdKNHFNTnV5MGNHMXY` ##NO_TEXT.
