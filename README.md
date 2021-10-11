# Salesforce Org Boilerplate

This Repository contains items that are useful in any Salesforce Org with that can be re-used without any code changes.

## Custom Logging

An easier way to catch and resolve Apex errors.

- CustomLog__c Custom Object
- CustomLogLevelSettings__c Custom Settings
    - Add a Number field to this Object with Name being the associated Apex Class. 
    - Let the value be the Max level log you wish to create for this class
        - e.g. if value = 3, then only logs with LogLevel <= 3 will be created
- CustomLogger.cls Apex Class
    - Call CustomLogger.log() or CustomLogger.logException() to create a CustomLog__c record
    - Validates that log records should be created based on CustomLogLevelSettings__c field values

