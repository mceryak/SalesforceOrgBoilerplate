@IsTest 
private class CustomLogDeletionJobTest {
    
    @TestSetup
    static void makeData(){
        Date today = Date.today();
        CustomLog__c clOld = new CustomLog__c(Occured__c = today.addMonths(-6).addDays(-1), Class__c = 'TestClass123');   
        CustomLog__c clNew = new CustomLog__c(Occured__c = today.addMonths(-6).addDays(1), Class__c = 'TestClass321');
        insert new CustomLog__c[] { clOld, clNew };
    }

    @IsTest 
    static void testBatchJob() {
        Test.startTest();
        Database.executeBatch(new CustomLogDeletionJob(Date.today().addMonths(-6)));
        Test.stopTest();
        CustomLog__c[] logs = [SELECT Occured__c FROM CustomLog__c];
        System.assertEquals(1, logs.size());
        System.assert(logs[0].Occured__c > Date.today().addMonths(-6), 'wrong log deleted, this log has Occured__c = ' + logs[0].Occured__c + '. 6 Months ago is: ' + Date.today().addMonths(-6));
    }

    @IsTest 
    static void testScheduler() {
        Test.startTest();
        CustomLogDeletionJobScheduler.scheduleEveryMonth();
        Test.stopTest();
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND ApexClass.Name = 'CustomLogDeletionJob' LIMIT 1];
        System.assertEquals('Queued', job.Status);
    }

}
