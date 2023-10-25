/**
 * AccountTrigger
 * 
 * Description: Single trigger for Account. Used for all conditions such as before insert, 
 *              after insert, before update, after update, before delete, after delete.
 * 
 * Created By: ssawant
 * Created on: 25.10.2023
 */
trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete) {
    System.debug('---- Acc Trigger run Inital ---->'+Trigger.New.size() );
	if (trigger.isInsert) {
        if (trigger.isBefore) {
         // Call before insert handler 
        }
        else {
          // Call after insert handler 
        }
      } 
      else if (trigger.isUpdate){
        if (trigger.isBefore) {
         // Call before update handler 
        }
        else { // Call after update handler 
        	System.debug('---- Acc Trigger run Main ---->'+Trigger.New.size() );
            Map<Id, Account> newAccsById = new Map<Id, Account>();
            Map<Id, Account> oldAccsById = new Map<Id, Account>();
            
            for(Account acc:trigger.new ){
                // Execute the records only if not already executed
                if( !TrhAccount.executedRecords.contains(acc.id) ){
                    newAccsById.put(acc.id, acc);
                    oldAccsById.put(acc.id, trigger.oldMap.get(acc.Id));
                }
            }
            TrhAccount.afterUpdate(oldAccsById, newAccsById);
        }
      }
}