@IsTest 
private class fflib_MethodVerifierTest {
    
    @IsTest 
    static void test_methodVerifier() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ExampleService mockService = (fflib_ExampleService)mocks.mock(fflib_ExampleService.class);

        Test.startTest();
        mockService.getString();
        mockService.getString();
        mockService.getNextInt(3);
        Test.stopTest();

        ((fflib_ExampleService)mocks.verify(mockService, new fflib_VerificationMode().atLeast(1))).getString();
        ((fflib_ExampleService)mocks.verify(mockService, 2)).getString();
        ((fflib_ExampleService)mocks.verify(mockService, 1)).getNextInt(3);
        try {
            ((fflib_ExampleService)mocks.verify(mockService, 3)).getString();   
        } catch (fflib_ApexMocks.ApexMocksException e) {
            // this was expected
        }
        try {
            ((fflib_ExampleService)mocks.verify(mockService, 1)).getNextInt(2);
        } catch (fflib_ApexMocks.ApexMocksException e) {
            // this was expected
        }
        new fflib_AnyOrder().capture(new fflib_IMatcher[] {new fflib_ArgumentCaptor.AnyObject(new fflib_ArgumentCaptor())});
    }

}