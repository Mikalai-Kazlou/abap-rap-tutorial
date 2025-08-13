" Creating the Service Consumption Model
" https://github.com/SAP-samples/abap-platform-rap-opensap/blob/main/week5/unit2.md

" Implement a Custom Entity and API Execution (Query Implementation) Class
" https://developers.sap.com/tutorials/abap-environment-a4c-create-custom-entity.html

" Get a user in ES5 is described in the following blog (https://blogs.sap.com/2017/12/05/new-sap-gateway-demo-system-available/).
" Download the $metadata file of the OData service we want to consume: https://sapes5.sapdevcenter.com/sap/opu/odata/sap/ZE2E100_SOL_2_SRV/$metadata
" Create Service Consumption Model with the name Z**_SC_BUSINESS_PARTNER using the downloaded metadata file (the entity set “SEPM_I_BUSINESSPARTNER_E” needs to be retrieved).
" The credentials are your user and password for ES5,
"   url = 'https://sapes5.sapdevcenter.com/'
"   service_root = '/sap/opu/odata/sap/ZE2E100_SOL_2_SRV/'.

CONSTANTS sc_service_url    TYPE string VALUE 'https://sapes5.sapdevcenter.com'       ##NO_TEXT.
CONSTANTS sc_service_root   TYPE string VALUE '/sap/opu/odata/sap/ZE2E100_SOL_2_SRV/' ##NO_TEXT.
CONSTANTS sc_proxy_model_id TYPE string VALUE 'ZRP_SC_BUSINESS_PARTNER'               ##NO_TEXT.
CONSTANTS sc_pcode          TYPE string VALUE `KJjE88c3gMRxqB$BD*BB9Rm677JY`          ##NO_TEXT.
CONSTANTS sc_ucode          TYPE string VALUE `0000124452736553`                      ##NO_TEXT.
