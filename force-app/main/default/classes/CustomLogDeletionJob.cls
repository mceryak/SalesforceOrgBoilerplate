/**
 * @author Mike Ceryak
 * @since 10/11/2021
 * 
 * Test Class: CustomLogDeletionJobTest
 * 
 * Description:
 * 
 *      Run this class on its own by passing in a GMT Date to delete all CustomLog__c records occuring before this date.
 *      Or, you can schedule this class to run once a month by running this script:
 * 
 *      CustomLogDeletionJobScheduler.scheduleEveryMonth();
 * 
 */
public with sharing class CustomLogDeletionJob implements Database.Batchable<sObject>, Database.Stateful {

    // all CustomLog__c records before this datetime will be deleted
    DateTime deleteBeforeDateTimeGmt;

    public CustomLogDeletionJob(Date deleteBeforeDateGmt) {
        this.deleteBeforeDateTimeGmt = DateTime.newInstanceGmt(deleteBeforeDateGmt, Time.newInstance(0, 0, 0, 0));
    }

    // query all records where Save__c is not true and that occur before the date given in constructor
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM CustomLog__c WHERE Save__c != TRUE AND Occured__c < ' + this.deleteBeforeDateTimeGmt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
    }

    public void execute(Database.BatchableContext bc, sObject[] logs) {
        delete logs;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Finished CustomLogDeletionJob');
    }

}
