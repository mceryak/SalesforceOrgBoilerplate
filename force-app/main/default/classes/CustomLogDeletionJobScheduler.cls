/**
 * @author Mike Ceryak
 * @since 10/11/2021
 * 
 * Test class: CustomLogDeletionJobTest 
 * Description: Schedule this class in the UI or anonymous apex simply with the scheduleEveryMonth() method
 */
public with sharing class CustomLogDeletionJobScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CustomLogDeletionJob(Date.today().addMonths(-6)));
    }

    // schedule this class to run on the first of every month at midnight
    public static void scheduleEveryMonth() {
        System.schedule(Test.isRunningTest() ? 'TEST_CustomLogDeletionJob' : 'CustomLogDeletionJob', '0 0 0 1 1/1 ? *', new CustomLogDeletionJobScheduler());
    }

}
