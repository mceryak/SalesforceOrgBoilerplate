# Salesforce Org Boilerplate

This Repository contains items that are useful in any Salesforce Org that can be re-used without any code changes.

## Custom Logger (lgr)

An easier way to catch and resolve Apex errors in production.

### Usage

1. For each Apex Class containing calls to the logger, add a custom text field to lgr_LogLevels__c Custom Settings:
    - Field Type: Text(8)
    - Field Api Name: The exact name of the Apex class containing the logger call
    - Field Value: `CRITICAL`, `WARNING`, `INFO`, or `DEBUG`
2. In the Apex Class, call the logger:
    - `lgr_Logger.log('className', 'methodName', 'message',  'parameters', 'stackTrace', lgr_Logger.LogLevel.INFO);`

        - (When possible, the DML insert is done asynchronously so that it does not affect the limits of the current transaction)
    - `lgr_Logger.log(someException, 'className', 'methodName', 'parameters');`
        - (A devoted method for logging exceptions, which utilizes a 'publish immediately' platform event so that the exception can be re-thrown)

3. Clone the `All` List View for Custom Logs and filter on the Apex Class you want to see logs for.

4. Log records stick around for a default of 3 months, and are deleted in a monthly deletion job (see deployment steps). To save an individual Log record, tick the `Save` checkbox on the page layout. To change the default lifetime of all logs, Update the value on `lgr_LogSettings__c` Custom Settings.

### Deployment Steps

1. Deploy Custom Settings metadata.
    - `sfdx project deploy start -x modules/lgr/manifest/lgr_package1.xml`

2. Insert Org Defaults for Custom Settings.
    - scripts/customSettingsOrgDefaults.apex

3. Deploy the rest of the metadata.
    - `sfdx project deploy start -x modules/lgr/manifest/lgr_package2.xml -l RunSpecifiedTests --tests lgr_LogDeletionJobTest lgr_LoggerTest`

4. Assign Viewer Permissions to all Admins.
    - /modules/lgr/scripts/assignViewerPermSet.apex

5. Schedule the Deletion job.
    - /modules/lgr/scripts/scheduleDeletionJob.apex



## Extendable Trigger Handler

The [Kevin Ohara Trigger Handler Framework](https://github.com/kevinohara80/sfdc-trigger-framework) with a small addition

- ProcessSwitches__c Custom Settings
    - Add a Checkbox field for each 'Process' (Apex Trigger, Flow, Process Builder) that you wish to make configurable
        - For Apex Triggers, the custom field must be the exact name of the class that extends TriggerHandler
    - When unchecked, the process will not run
- TriggerHandler.isTriggerActive() method
    - This additional method checks ProcessSwitches__c to see if this trigger has been configured to be inactive before running the trigger.
    - This method is called in run() method before executing handler code

