@isTest
public with sharing class PardotFormScheduler_Test {

  public static String pardotResponse = '{"values":[{"id":6803,"afterFormContent":"","beforeFormContent":"","campaignId":23875,"checkboxAlignment":"default","embedCode":"","labelAlignment":"above","layoutTemplateId":5719,"name":"Standard Form","radioAlignment":"default","submitButtonText":"Submit","thankYouContent":"<p>Thank you for filling out the form. We will get back to you shortly.</p>"}]}';

  @isTest
  public static void testSchedulerService() {
    PardotForm_MockFactory mock = new PardotForm_MockFactory(
      200,
      'OK',
      pardotResponse,
      new Map<String, String>()
    );
    Test.setMock(HttpCalloutMock.class, mock);

    Test.startTest();
    PardotFormScheduler scheduler = new PardotFormScheduler();
    String chron = '0 0 23 * * ?';
    System.schedule('Pardot Form Test Job', chron, scheduler);
    Test.stopTest();

    List<AsyncApexJob> scheduledJobs = [
      SELECT Id
      FROM AsyncApexJob
      WHERE JobType = 'ScheduledApex'
    ];
    System.assert(scheduledJobs.size() >= 1, 'Expecting a Schedule Batch Job');
  }
}