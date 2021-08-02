@isTest
public with sharing class PardotFormCallout_Test {

  public static String pardotResponse = '{"values":[{"id":6803,"afterFormContent":"","beforeFormContent":"","campaignId":23875,"checkboxAlignment":"default","embedCode":"","labelAlignment":"above","layoutTemplateId":5719,"name":"Standard Form","radioAlignment":"default","submitButtonText":"Submit","thankYouContent":"<p>Thank you for filling out the form. We will get back to you shortly.</p>"}]}';

  @isTest
  static void invokeCallout() {
    PardotForm_MockFactory mock = new PardotForm_MockFactory(
      200,
      'OK',
      pardotResponse,
      new Map<String, String>()
    );
    Test.setMock(HttpCalloutMock.class, mock);

    Test.startTest();
    PardotFormCallout.getPardotForms();
    Test.stopTest();
    List<plabs__PardotForm__c> forms = [SELECT Id FROM plabs__PardotForm__c];
    system.assert(forms.size() >= 1, 'The form\'s we\'re not correctly upserted');
  }

}