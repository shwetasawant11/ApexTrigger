/**
 * TrhContact
 * 
 * Description: Trigger handler for Contact trigger. Contains the business logic to be executed after 
 *              triggering conditions such as before insert, after insert, before update, after update, 
 *              before delete, after delete.
 * 
 * Created By: ssawant
 * Created on: 25.10.2023
 */
public class TrhContact {
    // static variables
    // To keep track which all records have been executed
    public static Set<Id> executedRecords = new Set<Id>();
    
	// Insert Trigger handlers
    public static void beforeInsert(List<Contact> newList){        
    }
    public static void afterInsert(List<Contact> newList){
    }

    // Update Trigger handlers
    public static void beforeUpdate(List<Contact> oldList, List<Contact> newList){        
    }
    
    // All the business logic for After update handler for Contact should appear here 
    public static void afterUpdate(Map<Id, Contact> oldConsById,  Map<Id, Contact> newConsById){
        List<Contact> oldList = new List<Contact>();
        List<Contact> newList = new List<Contact>();
        
        for(Contact con: newConsById.values()  ){
            // This is an extra check so that the contacts which are already 
            // updated do not enter in to the handler once again
			// If the isActive flag is changed, only then execute the records            
            if( con.Activated__c != oldConsById.get(con.Id).Activated__c  ){
                newList.add(con);
                oldList.add(oldConsById.get(con.Id));
            }
        }
        // Enter the handler only if the field is changed
        if(newList.size()> 0){
            updateAccountsAndContacts( oldList, newList);
        }
    }    
    
    
    public static void updateAccountsAndContacts(List<Contact> oldList, List<Contact> newList){        
        Map<Id, Contact> ConByAccId = new Map<Id, Contact>();
        Set<Id> accIds = new Set<Id>();
        Set<Id> conIds = new Set<Id>();
        List<Account> accs = new List<Account>();
        List<Contact> cons = new List<Contact>();
        Boolean isActiveToUpdate;
		
        //1. Get the accout and contact ids
        for(Contact c:  newList ){            
            executedRecords.add(c.Id);
            accIds.add(c.AccountId); // Collect all account ids
            conIds.add(c.Id); // Collect all contact ids
            // Create a map of all contacts by their account ids to use later
            if(!ConByAccId.containsKey(c.AccountId)){
                ConByAccId.put(c.AccountId, c );
            }
        }
        
        //2. Get accounts from the account ids
        for(Account acc: [ SELECT id, Activated__c from Account where id IN : accIds]){
            // Get the triggering contacts status
            isActiveToUpdate = ConByAccId.get(acc.Id).Activated__c;
          	
            // 3. filter the accounts once again to minimise the updates
            // The status should be set based on the status of the triggering record
            // Do not process the record if the status is already correct
            if(acc.Activated__c != isActiveToUpdate){
                acc.Activated__c = isActiveToUpdate;
                accs.add(acc);
            }
        }        
        
        //4. Update accounts first
        if(accs.size()>0){
            System.debug('---- to update accs ---->'+accs.size() );
            Database.update(accs,false); // Due to this update, the Account trigger gets called
        }
        
        
        //5. Get the contacts based on the account ids; also skip updating the triggering contact records
        for(Contact con : [ SELECT AccountId, Activated__c from Contact where AccountId IN : accIds AND  Id NOT IN : conIds ]){
            
            isActiveToUpdate = ConByAccId.get(con.AccountId).Activated__c;
          	
            //6. Extra filter to minimise the number of rows getting updated
            if(con.Activated__c != isActiveToUpdate){
                con.Activated__c = isActiveToUpdate;
                cons.add(con);
            }
        }
        
        //6. Update contacts
        if(cons.size()>0){
            System.debug('---- to update cons ---->'+cons.size() );
            Database.update(cons, false);
        } 
    }
}