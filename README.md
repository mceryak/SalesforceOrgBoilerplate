# Salesforce Org Boilerplate

This Repository contains items that are useful in any Salesforce Org that can be re-used without any code changes.

## Custom Logging

An easier way to catch and resolve Apex errors.

- lgr_Log__c Custom Object
    - Class__c: Apex Class name where log occured
    - LogLevel__c: The priority of the log, lower number is higher priority, Must be in range [1, 9]
    - Method__c: Apex Method name where log occured
    - Message__c: Long text field to describe what happened
    - Occured__c: DateTime that the log occured
    - Parameters__c: Long text field to add necessary data
    - StackTrace__c: Exact line of code where an Error occured
    - Save__c: When checked, this record will never be auto-deleted in CustomLogDeletionJob batch job
- CustomLogLevelSettings__c Custom Settings
    - Add a Number field to this Object with Name being the associated Apex Class. 
    - Let the field value be the Max log level you wish to create for this class
        - e.g. if value = 3, then only lgr_Log__c records with LogLevel__c <= 3 will be created
        - If field value = 0, no logs will be created for this class
- CustomLogger Apex Class
    - Call CustomLogger.log() or CustomLogger.logException() to create a lgr_Log__c record
    - Validates that log records should be created based on CustomLogLevelSettings__c field values
    - Inserts a log in an @future method when possible to avoid using up dml statements
- CustomLogDeletionJob and CustomLogDeletionJobScheduler Apex Classes
    - Execute `CustomLogDeletionJobScheduler.scheduleEveryMonth();` to run the CustomLogDeletionJob batch job that deletes lgr_Log__c records older than 6 months that do not have the Save__c field checked.

## Extendable Trigger Handler

The [Kevin Ohara Trigger Handler Framework](https://github.com/kevinohara80/sfdc-trigger-framework) with a small addition

- ProcessSwitches__c Custom Settings
    - Add a Checkbox field for each 'Process' (Apex Trigger, Flow, Process Builder) that you wish to make configurable
        - For Apex Triggers, the custom field must be the exact name of the class that extends TriggerHandler
    - When unchecked, the process will not run
- TriggerHandler.isTriggerActive() method
    - This additional method checks ProcessSwitches__c to see if this trigger has been configured to be inactive before running the trigger.
    - This method is called in run() method before executing handler code

