public without sharing class PardotFormController {

    @AuraEnabled
    public static plabs__PardotForm__c getSelectedForm(Id recordId){
        List<plabs__PardotForm__c> forms = [SELECT Id, Name, plabs__Response__c, plabs__EmbedCode__c, plabs__FormURL__c FROM plabs__PardotForm__c WHERE Id =: recordId LIMIT 1];
        return forms[0];}

    @AuraEnabled
    public static List<plabs__PardotForm__c> getAllForms(){
        List<plabs__PardotForm__c> forms = [SELECT Id, Name, plabs__Response__c, plabs__EmbedCode__c, plabs__FormURL__c, plabs__Active__c, plabs__Description__c FROM plabs__PardotForm__c WHERE plabs__Active__c = true];
        return forms;
}

    @AuraEnabled
    public static List<plabs__Pardot_Forms_Configuration__mdt> getConfig(){
        List<plabs__Pardot_Forms_Configuration__mdt> config = [SELECT plabs__Business_Unit_Id__c, plabs__Endpoint_URL__c FROM plabs__Pardot_Forms_Configuration__mdt WHERE DeveloperName = 'main'];
        return config;
}

}