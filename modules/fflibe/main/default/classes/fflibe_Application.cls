public inherited sharing virtual class fflibe_Application extends fflib_Application {
    
    // This version of ServiceFactory does not maintain an interface mapping, only a mock class mapping.
    // This way, we don't have to maintain an interface mapping and can immediately create a new service class.
    public virtual class ServiceFactory extends fflib_Application.ServiceFactory {

        public ServiceFactory() {
            m_serviceInterfaceTypeByMockService = new Map<Type,Object>();
        }
        
        public virtual override Object newInstance(Type serviceType) {
            if(m_serviceInterfaceTypeByMockService.containsKey(serviceType))
				return m_serviceInterfaceTypeByMockService.get(serviceType);

            // don't check interface mapping, since we are expecting the exact type of class
            return serviceType.newInstance();
        }

    }

    public virtual class SelectorFactory extends fflib_Application.SelectorFactory {

        // private Map<String, String> sObjectNameToClassNameMappings;

        // instead of defining the mapping in an Application class, it is defined in custom metadata
        // so that when multiple developers are working, they are not constantly editing the same
        // application class
        public SelectorFactory() {
            super(new Map<SObjectType, Type>());
            for (fflibe_SelectorMapping__mdt mapping : fflibe_MetadataHelper.getSelectorMappings()) {
                try {
                    SObjectType sObjType = ((SObject)Type.forName('Schema.' + mapping.SObjectType__c).newInstance()).getSObjectType();
                    Type classType = Type.forName(mapping.SelectorClass__c);
                    this.m_sObjectBySelectorType.put(sObjType, classType);
                } catch (Exception e) {
                    lgr_Logger.log(e, 'fflibe_Application', 'SelectorFactory init', 'selector mapping: ' + mapping);
                    throw e;
                }
            }
        }

    }

}