@IsTest 
private class fflibe_ApplicationTest {
    
    @IsTest 
    static void test_serviceFactory() {
        fflibe_TESTService service = (fflibe_TESTService)fflibe_APP.SERVICE.newInstance(fflibe_TESTService.class);
        System.assertEquals(7, service.get7());

        // now mock the service
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflibe_TESTService mockService = (fflibe_TESTService)mocks.mock(fflibe_TESTService.class);
        fflibe_APP.SERVICE.setMock(fflibe_TESTService.class, mockService);

        mocks.startStubbing();
        mocks.when(mockService.get7()).thenReturn(8);
        mocks.stopStubbing();

        // this should return the mock service with the stubbed method returning 8 instead of 7
        service = (fflibe_TESTService)fflibe_APP.SERVICE.newInstance(fflibe_TESTService.class);
        System.assertEquals(8, service.get7());
    }

    

    @IsTest 
    static void test_selectorFactory() {
        fflibe_MetadataHelper.returnMockData = true;
        Test.startTest();
        fflib_ISObjectSelector selector1 = fflibe_APP.SELECTOR.newInstance(Account.getSObjectType());
        fflib_ISObjectSelector selector2 = fflibe_APP.SELECTOR.newInstance(Contact.getSObjectType());
        try {
            fflib_ISObjectSelector selector3 = fflibe_APP.SELECTOR.newInstance(Opportunity.getSObjectType());
            System.assert(false, 'not opp selector set up');
        } catch (fflib_Application.DeveloperException e) {}
        catch (Exception e) {
            System.assert(false, 'wrong exception: ' + e.getMessage());
        }
        Test.stopTest();

        System.assertEquals(Account.getSObjectType(), selector1.sObjectType());
        System.assertEquals(Contact.getSObjectType(), selector2.sObjectType());
    }

}