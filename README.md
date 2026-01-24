# ABAP RAP Tutorial

## Package
- Name - `ZRP_ABAP_RAP_TUTORIAL`
- Description - `ABAP RAP Tutorial`

## Restore SOAP Service Consumption Model
- Tutorial - [Consume SOAP Based Web Services with SAP BTP, ABAP Environment](https://developers.sap.com/tutorials/abap-environment-soap-web-services.html)
- Service Description - [link](http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso)
- Service WSDL - [link](http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso?WSDL) (download is required)
- Name of Service Consumption Model - `ZRP_SC_COUNTRY_INFO`
- Prefix - `ZRP_SC_`
- Activate the Service Consumption Model

## Restore OData Service Consumption Model
- Create a user in [api.sap.com](https://api.sap.com)
- Download the `$metadata` file of the `BUSINESS_PARTNER_A2X` OData service: [link](https://api.sap.com/api/API_BUSINESS_PARTNER/overview)
- Create Service Consumption Model with the name `ZRP_SC_BUSINESS_PARTNER` using the downloaded metadata file
- Activate the Service Consumption Model
