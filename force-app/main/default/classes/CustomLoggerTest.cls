@IsTest
private class CustomLoggerTest {

    final static String CLASS_NAME = 'TestClassName';
    final static String METHOD_NAME = 'TestMethodName';

    static String exMessage;
    static String exStackTrace;

    @TestSetup
    static void makeData(){
        CustomLogLevelSettings__c defaultSetting = new CustomLogLevelSettings__c(SetupOwnerId=UserInfo.getOrganizationId());
        defaultSetting.put(CLASS_NAME + '__c', 2);
        insert defaultSetting;   
    }


    // TEST METHODS

    @IsTest
    static void testLogException() {
        Test.startTest();
        DateTime beforeOccured = System.now().addSeconds(-1);
        logException();
        DateTime afterOccured = System.now().addSeconds(1);
        Test.stopTest();
        assertLogFields(beforeOccured, afterOccured, exMessage, exStackTrace, 1, 'x = null');
    }
    
    @IsTest 
    static void testLogException_FromFuture() {
        Test.startTest();
        logExceptionFromFutureMethod();
        DateTime beforeOccured = System.now().addSeconds(-1);
        Test.stopTest();
        DateTime afterOccured = System.now().addSeconds(1);
        assertLogFields(beforeOccured, afterOccured, exMessage, exStackTrace, 1, 'x = null');
    }

    @IsTest 
    static void testLog() {
        Test.startTest();
        DateTime beforeOccured = System.now().addSeconds(-1);
        log();
        DateTime afterOccured = System.now().addSeconds(1);
        Test.stopTest();
        assertLogFields(beforeOccured, afterOccured, 'test info message', 'test info stack trace', 2, 'test info params');
    }

    @IsTest 
    static void testLog_FromFuture() {
        Test.startTest();
        logFromFutureMethod();
        DateTime beforeOccured = System.now().addSeconds(-1);
        Test.stopTest();
        DateTime afterOccured = System.now().addSeconds(1);
        assertLogFields(beforeOccured, afterOccured, 'test info message', 'test info stack trace', 2, 'test info params');
    }

    @IsTest 
    static void testLog_LogLevel1() {
        // insert setting for log level <= 1
        CustomLogLevelSettings__c profileSetting = new CustomLogLevelSettings__c(SetupOwnerId=UserInfo.getProfileId());
        profileSetting.put(CLASS_NAME + '__c', 1);
        insert profileSetting;   

        Test.startTest();
        log(); // log level 2 (should not log)
        logException(); // log level 1 (should log)
        Test.stopTest();
        System.assertEquals(1, [SELECT Count() FROM CustomLog__c]);
        System.assertEquals(1, Integer.valueOf([SELECT LogLevel__c FROM CustomLog__c].LogLevel__c));
    }

    @IsTest 
    static void testLog_LogLevel0() {
        // insert setting for log level == 0
        CustomLogLevelSettings__c userSetting = new CustomLogLevelSettings__c(SetupOwnerId=UserInfo.getUserId());
        userSetting.put(CLASS_NAME + '__c', 0);
        insert userSetting;  

        Test.startTest();
        log(); // log level 2 (should not log)
        logException(); // log level 1 (should not log)
        Test.stopTest();
        System.assertEquals(0, [SELECT Count() FROM CustomLog__c]);
    }

    @IsTest 
    static void testLog_InvalidLogLevel() {
        Boolean causedException = false;
        Test.startTest();
        try {
            CustomLogger.log('className', 'methodName', 'message', 'parameters', 'stackTrace', 0);
        } catch (CustomLogger.CustomLogException e) {
            causedException = true;
        }
        Test.stopTest();
        System.assert(causedException, 'Did not cause CustomLogException');
    }

    @IsTest 
    static void testInsertLogFailure() {
        CustomLog__c log = new CustomLog__c();
        Test.startTest();
        CustomLogger.handleLogInsert(log);
        Test.stopTest();
        System.assertEquals(0, [SELECT Count() FROM CustomLog__c]);
    }

    @IsTest 
    static void testLog_NoSettingFound() {
        Test.startTest();
        CustomLogger.log('RandomClassName', 'MEthodName', 'message', 'parameters', 'stackTrace', 1);
        Test.stopTest();
        System.assertEquals(1, [SELECT Count() FROM CustomLog__c]);
    }


    // HELPER METHODS

    static void logException() {
        Integer x;
        try {
            x += 3;
            System.assert(false, 'exception should be thrown before this statement');
        } catch(NullPointerException ex) {
            CustomLogger.logException(ex, 'TestClassName', 'TestMethodName', 'x = ' + x);
            exMessage = ex.getMessage();
            exStackTrace = ex.getStackTraceString().replace('\n', ' ');
        }
    }

    static void log() {
        CustomLogger.log(CLASS_NAME, METHOD_NAME, 'test info message', 'test info params', 'test info stack trace', 2);
    }

    @future
    static void logExceptionFromFutureMethod() {
        logException();
    }

    @future 
    static void logFromFutureMethod() {
        log();
    }

    static void assertLogFields(DateTime beforeOccured, DateTime afterOccured, String message, String stackTrace, Integer logLevel, String params) {
        CustomLog__c log = [SELECT Class__c, Method__c, Parameters__c, LogLevel__c, StackTrace__c, Message__c, Occured__c FROM CustomLog__c];
        System.assertNotEquals(null, log);
        System.assertEquals(CLASS_NAME, log.Class__c);
        System.assertEquals(METHOD_NAME, log.Method__c);
        System.assertEquals(message, log.Message__c);
        System.assertEquals(stackTrace, log.StackTrace__c, 'my expected = "' + exStackTrace + '", my actual = "' + log.StackTrace__c + '"');
        System.assertEquals(logLevel, log.LogLevel__c);
        System.assertEquals(params, log.Parameters__c);
        System.assert(log.Occured__c < afterOccured && log.Occured__c > beforeOccured, 'Occured__c time is not accurate. log.Occured = ' + log.Occured__c + ', beforeOccured = ' + beforeOccured + ', afterOccured = ' + afterOccured);
    }

}