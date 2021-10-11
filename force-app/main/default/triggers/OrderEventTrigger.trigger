trigger OrderEventTrigger on Order_Event__e (after insert) {
    
    Task[] tasks = new List<Task>();
    for (Order_Event__e evt : Trigger.new) {
        if (evt.Has_Shipped__c) {  
            tasks.add(new Task(Priority='Medium', Subject='Follow up on shipped order ' + evt.Order_Number__c, OwnerId=evt.CreatedById));
        }
    }
    
    if (!tasks.isEmpty()) insert tasks;

}