/**
 * TrhAccount
 * 
 * Description: Trigger handler for Account trigger. Contains the business logic to be executed after 
 *              triggering conditions such as before insert, after insert, before update, after update, 
 *              before delete, after delete.
 * 
 * Created By: ssawant
 * Created on: 25.10.2023
 */
public class TrhAccount {
	// static variables
	// // To keep track which all records have been executed
    public static Set<Id> executedRecords = new Set<Id>();
    
	// Insert Trigger handlers
    public static void beforeInsert(List<Account> newList){        
    }
    public static void afterInsert(List<Account> newList){
    }

    // Update Trigger handlers
    public static void beforeUpdate(List<Account> oldList, List<Contact> newList){        
    }
    
    public static void afterUpdate(Map<Id, Account> oldAccsById,  Map<Id, Account> newAccsById){
        List<Account> oldList = new List<Account>();
        List<Account> newList = new List<Account>();
        for(Account acc: newAccsById.values()  ){
            // If the isActive flag is changed, only then execute the records 
            if( acc.Activated__c != oldAccsById.get(acc.Id).Activated__c  ){
                newList.add(acc);
                oldList.add(oldAccsById.get(acc.Id));
            }
        }
        // Enter the handler only if the field is changed
        if(newList.size()> 0){
            updateAccountsAndContacts( oldList, newList);
        }        
    }
    
    public static void updateAccountsAndContacts(List<Account> oldList, List<Account> newList){
        System.debug('---- Acc Trigger handler run ---->'+newList.size() );       
        Map<Id, Account> accByAccId = new Map<Id, Account>();
        Set<Id> accIds = new Set<Id>();       
        List<Contact> cons = new List<Contact>();
        Boolean isActiveToUpdate;
        
        for(Account acc:  newList ){            
            executedRecords.add(acc.Id);
            accIds.add(acc.Id);
            // Create a map of all accounts by their account ids to use later
            if(!accByAccId.containsKey(acc.Id)){
                accByAccId.put(acc.Id, acc );
            }
        }
        
        for(Contact con : [ SELECT AccountId, Activated__c from Contact where AccountId IN : accIds ]){
            isActiveToUpdate = accByAccId.get(con.AccountId).Activated__c;
            
            if(con.Activated__c != isActiveToUpdate){
                con.Activated__c	= isActiveToUpdate;
                cons.add(con);
            }
        }        
        
        if(cons.size()>0){
            System.debug('---- to update cons ---->'+cons.size() );
            update cons;
        }
    }
}