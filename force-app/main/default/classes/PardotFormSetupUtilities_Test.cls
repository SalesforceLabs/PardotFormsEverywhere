@isTest
public with sharing class PardotFormSetupUtilities_Test {

    public static String pardotResponse = '{"values":[{"id":6803,"afterFormContent":"","beforeFormContent":"","campaignId":23875,"checkboxAlignment":"default","embedCode":"","labelAlignment":"above","layoutTemplateId":5719,"name":"Standard Form","radioAlignment":"default","submitButtonText":"Submit","thankYouContent":"<p>Thank you for filling out the form. We will get back to you shortly.</p>"}]}';

    @isTest
    public static void checkFirstJobStatus() {
        PardotForm_MockFactory mock = new PardotForm_MockFactory(
        200,
        'OK',
        pardotResponse,
        new Map<String, String>()
      );
      Test.setMock(HttpCalloutMock.class, mock);
      Test.startTest();
      Datetime dateandtime = PardotFormSetupUtilities.getCurrentDateTime();
      PardotFormScheduler scheduler = new PardotFormScheduler();
      String cron = '0 0 23 * * ?';
      System.schedule('PardotFormTest', cron, scheduler);
      PardotFormSetupUtilities.checkFirstJobStatus(dateandtime);
      Test.stopTest();
  
      List<CronTrigger> cronTriggers = [
        SELECT Id, CronExpression
        FROM CronTrigger
        WHERE CronJobDetail.Name = 'PardotFormTest'
        LIMIT 1
      ];
      System.assert(cronTriggers.size() >= 1, 'Expecting a Schedule Batch Job');
    }
  

    @isTest
    public static void getCurrentScheduleCron() {
        PardotForm_MockFactory mock = new PardotForm_MockFactory(
        200,
        'OK',
        pardotResponse,
        new Map<String, String>()
      );
      Test.setMock(HttpCalloutMock.class, mock);
  
      Test.startTest();
      PardotFormScheduler scheduler = new PardotFormScheduler();
      String cron = '0 0 23 * * ?';
      System.schedule('PardotFormTest', cron, scheduler);
      PardotFormSetupUtilities.getCurrentScheduleCron();
      Test.stopTest();
  
      List<CronTrigger> cronTriggers = [
        SELECT Id, CronExpression
        FROM CronTrigger
        WHERE CronJobDetail.Name = 'PardotFormTest'
        LIMIT 1
      ];
      System.assert(cronTriggers.size() >= 1, 'Expecting a Schedule Batch Job');
    }
  
    @isTest
    public static void testScheduleSecuritySync_positive() {
        PardotForm_MockFactory mock = new PardotForm_MockFactory(
        200,
        'OK',
        pardotResponse,
        new Map<String, String>()
      );
      Test.setMock(HttpCalloutMock.class, mock);
  
      Test.startTest();
      String cron = '0 0 23 * * ?';
      PardotFormSetupUtilities.scheduleSync(cron);
      Test.stopTest();
  
      List<CronTrigger> cronTriggers = [
        SELECT Id, CronExpression
        FROM CronTrigger
        WHERE CronJobDetail.Name = 'PardotFormScheduler'
        LIMIT 1
      ];
      System.assert(cronTriggers.size() >= 1, 'Expecting a Schedule Batch Job');
    }
  
    @isTest
    public static void testDeleteScheduledJob_positive() {
        PardotForm_MockFactory mock = new PardotForm_MockFactory(
        200,
        'OK',
        pardotResponse,
        new Map<String, String>()
      );
      Test.setMock(HttpCalloutMock.class, mock);
  
      Test.startTest();
      PardotFormScheduler scheduler = new PardotFormScheduler();
      String cron = '0 0 23 * * ?';
      System.schedule('PardotFormScheduler', cron, scheduler);
      PardotFormSetupUtilities.deleteScheduledJob();
      Test.stopTest();
  
      List<CronTrigger> cronTriggers = [
        SELECT Id, CronExpression
        FROM CronTrigger
        WHERE CronJobDetail.Name = 'PardotFormScheduler'
        LIMIT 1
      ];
      CronTrigger cronTrigger = (cronTriggers.size() == 1) ? cronTriggers.get(0) : null;
      System.assert(cronTrigger == null, 'Job Should Be Deleted');
    }
  }