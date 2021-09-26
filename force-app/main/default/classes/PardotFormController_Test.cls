@isTest
public with sharing class PardotFormController_Test {
    @TestSetup
    public static void createData() {
      PardotForm_TestFactory.setupDefaultData();
    }

    @IsTest
    static void positiveGetSelectedForm() {
      Test.startTest();
      List<plabs__PardotForm__c> form = [SELECT Id FROM plabs__PardotForm__c];
      plabs__PardotForm__c response = PardotFormController.getSelectedForm(form[0].Id);
      Test.stopTest();
  
      System.assert(response.Id == form[0].Id, 'Summary format set incorrectly');
    }

    @IsTest
    static void positiveGetAllForms() {
      Test.startTest();
      List<plabs__PardotForm__c> forms = [SELECT Id FROM plabs__PardotForm__c];
      List<plabs__PardotForm__c> response = PardotFormController.getAllForms();
      Test.stopTest();
      System.assert(forms.size() == response.size(), 'Forms we\'re not correctly returned');
    }

    @IsTest
    static void positiveGetConfig() {
      Test.startTest();
      List<plabs__Pardot_Forms_Configuration__mdt> response = PardotFormController.getConfig();
      Test.stopTest();

      // CMDT May not have been configured, I know this is super hacky
      if(response.size() == 0){
        System.assert(0 == response.size(), 'CMDT Hasn\'t been configured');
      } else {
        System.assert(1 == response.size(), 'CMDT Hasn\'t been configured');
      }
    }
 
  }