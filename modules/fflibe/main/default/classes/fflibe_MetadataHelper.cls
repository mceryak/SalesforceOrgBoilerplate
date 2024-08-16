// Purpose of this class is so that custom metadata can easily be mocked
public inherited sharing class fflibe_MetadataHelper {

    @TestVisible
    private static Boolean returnMockData = false;

    public static fflibe_SelectorMapping__mdt[] getSelectorMappings() {
        return (Test.isRunningTest() && returnMockData) 
            ? new fflibe_SelectorMapping__mdt[] {
                new fflibe_SelectorMapping__mdt(SObjectType__c = 'Account', SelectorClass__c = 'fflibe_TESTSelector1', DeveloperName = 'Account'),
                new fflibe_SelectorMapping__mdt(SObjectType__c = 'Contact', SelectorClass__c = 'fflibe_TESTSelector2', DeveloperName = 'Contact')
            }
            : fflibe_SelectorMapping__mdt.getAll().values();
    }

}