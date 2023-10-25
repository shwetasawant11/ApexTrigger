/**
 * ContactTrigger
 * 
 * Description: Single trigger for Contact. Used for all conditions such as before insert, 
 *              after insert, before update, after update, before delete, after delete.
 * 
 * Created By: ssawant
 * Created on: 25.10.2023
 */
trigger ContactTrigger on Contact (before insert, after insert, before update, after update, before delete, after delete) {    
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
            Map<Id, Contact> newConsById = new Map<Id, Contact>();
            Map<Id, Contact> oldConsById = new Map<Id, Contact>();
            
            for(Contact con:trigger.new ){
                // Execute the records only if not already executed
                if( !TrhContact.executedRecords.contains(con.id) ){
                    newConsById.put(con.id, con);
                    oldConsById.put(con.id, trigger.oldMap.get(con.Id));
                }
            }
            TrhContact.afterUpdate(oldConsById, newConsById);
        }
      }
}