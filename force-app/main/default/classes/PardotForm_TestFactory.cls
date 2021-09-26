@isTest
public with sharing class PardotForm_TestFactory {

  public static void setupDefaultData() {
    plabs__PardotForm__c pform = createPardotForm();
  }

  public static PardotForm__c createPardotForm() {
    plabs__PardotForm__c pform = new plabs__PardotForm__c();
    pform.Name = 'Standard Form';
    pform.plabs__EmbedCode__c = '<iframe></iframe>';
    pform.plabs__Response__c = '{"value":"foo}';
    pform.plabs__Active__c = true;
    pform.plabs__FormId__c = '123456';
    pform.plabs__Description__c = 'Hello';
    insert pform;
    return pform;
  }
}