global with sharing class PardotFormCallout {    
    //Create a classs to parse the sessionID from the APEX page.
    public class SessionId {
        public string sessionId;
    }
    
    //Get the session ID from the APEX Page
    @AuraEnabled
    public static string getUserSessionId() {
        SessionId sessionJson = new SessionId();
        if(!Test.isRunningTest()){
            system.debug(Page.plabs__PardotSession.getContent().toString());
            sessionJson = (SessionId)JSON.deserialize(Page.plabs__PardotSession.getContent().toString(), SessionId.class);
        }
        return sessionJson.sessionId;
    }
    
    @Future(callout = true)
    public static void getPardotForms(){
         //Set up the authorization header for the API request
        String sessionId = getUserSessionId();
        String authorizationHeader = 'Bearer '+ sessionId; 
        
        plabs__Pardot_Forms_Configuration__mdt config = [SELECT plabs__Business_Unit_Id__c, plabs__Endpoint_URL__c FROM plabs__Pardot_Forms_Configuration__mdt WHERE DeveloperName = 'main'];
        system.debug('config: ' + config);
        String pardotUrl = 'https://' + config.plabs__Endpoint_URL__c + '/api/v5/objects/forms';
        String buid = config.plabs__Business_Unit_Id__c;

        //Set up the fields to request
        String reqFields = '?fields=id,name,campaignId,embedCode,layoutTemplateId,submitButtonText,beforeFormContent,afterFormContent,thankYouContent,labelAlignment,radioAlignment,checkboxAlignment';
        String response = null;
        
        //Set up the HTTP Classes
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        
        //Create the HTTPS Request Parameters
        req.setEndpoint(pardotUrl + reqFields);
        req.setMethod('GET');
        req.setHeader('Pardot-Business-Unit-Id', buid);
        req.setHeader('Authorization', authorizationHeader);
        
        //Print out the request to logs
        System.debug('Request:' + req);
        
        //Submit the request
        try {
            res = http.send(req);
            response = res.getBody();
            System.debug('Response: ' + response);
            PardotFormParser pardotForms = PardotFormParser.parse(response);
            System.debug('Parsed Response'+ pardotForms);
            List<plabs__PardotForm__c> formsToUpsert = new List<plabs__PardotForm__c>();
            for (PardotFormParser.values data : pardotForms.Values){
                plabs__PardotForm__c newForm = new plabs__PardotForm__c();
                newForm.plabs__EmbedCode__c = data.embedCode;
                newForm.Name = data.name;
                newForm.plabs__FormId__c = String.valueOf(data.id);
                formsToUpsert.add(newForm);
            }
            SObjectAccessDecision sanitisedRecords = Security.stripInaccessible(
                AccessType.CREATABLE,
                formsToUpsert
              );
              formsToUpsert = sanitisedRecords.getRecords();
              upsert formsToUpsert plabs__FormId__c;          
        }catch(System.CalloutException e){
            System.debug('Callout Error' + e);
            System.debug(res.getBody());
        }
    }   
}