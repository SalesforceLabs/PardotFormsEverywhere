public with sharing class PardotFormSetupUtilities {
      /**
   * The setup utilities are used to manage scheduled jobs throughout the app. With these you can see the details
   * of a schedule job, schedule a job, sor delete a scheduled job.
   */
  @AuraEnabled
  public static void runFirstJob() {
    PardotFormCallout.getPardotForms();        
}

  @AuraEnabled
  public static Datetime getCurrentDateTime() {
    return Datetime.now();
  }

  @AuraEnabled
  public static AsyncApexJob checkFirstJobStatus(Datetime submittedDatetime) {
    List<AsyncApexJob> asyncApexJobs = [
      SELECT Id, Status, ExtendedStatus
      FROM AsyncApexJob
      WHERE MethodName = 'getPardotForms' AND CompletedDate >= :submittedDatetime
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    AsyncApexJob asyncApexJob = (asyncApexJobs.size() == 1) ? asyncApexJobs.get(0) : null;

    if (asyncApexJob != null) {
      return asyncApexJob;
    }

    return null;
  }

  @AuraEnabled
  public static String getCurrentScheduleCron() {
    List<CronTrigger> cronTriggers = [
      SELECT Id, CronExpression
      FROM CronTrigger
      WHERE CronJobDetail.Name = 'PardotFormScheduler'
      LIMIT 1
    ];
    CronTrigger cronTrigger = (cronTriggers.size() == 1) ? cronTriggers.get(0) : null;
    if (cronTrigger != null) {
      return cronTrigger.CronExpression;
    } else {
      return 'unscheduled';
    }
  }

  @AuraEnabled
  public static Boolean scheduleSync(String cronString) {
    system.debug(cronString);
    try {
    PardotFormScheduler scheduler = new PardotFormScheduler();
      System.schedule('PardotFormScheduler', cronString, scheduler);
      return true;
    } catch (Exception e) {
      System.debug(e.getMessage());
      return false;
    }
  }

  @AuraEnabled
  public static Boolean deleteScheduledJob() {
    try {
      List<CronTrigger> cronTriggers = [
        SELECT Id, CronExpression
        FROM CronTrigger
        WHERE CronJobDetail.Name = 'PardotFormScheduler'
        LIMIT 1
      ];
      CronTrigger cronTrigger = (cronTriggers.size() == 1) ? cronTriggers.get(0) : null;

      System.abortJob(cronTrigger.Id);

      return true;
    } catch (Exception e) {
      System.debug(e.getMessage());

      return false;
    }
  }
}