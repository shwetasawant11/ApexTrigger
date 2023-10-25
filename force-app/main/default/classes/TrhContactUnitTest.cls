/**
 * TrhContactUnitTest
 * 
 * Description: Unit test for Trigger Handler for Contact
 * 
 * Created By: ssawant
 * Created on: 25.10.2023
 */
@isTest(SeeAllData=false)
public class TrhContactUnitTest {
    public static void createData(){
        // create account
        Account acc = new Account(Name='TestAccount', Activated__c=true);
        insert acc;
        
        // create contact
        Contact con1 = new Contact(FirstName='First1', LastName='Last1', AccountId=acc.Id,  Activated__c=true);
        insert con1;
        
        Contact con2 = new Contact(FirstName='First2', LastName='Last2', AccountId=acc.Id,  Activated__c=true);
        insert con2;
    }
    
    @isTest
    public static void updateAccountInactiveContactsInactive(){        
        createData();
        // Verify initial values
        Account acc = [SELECT Activated__c FROM Account].get(0);
        Contact con1 = [SELECT Activated__c FROM Contact WHERE FirstName='First1'].get(0);        
        Contact con2 = [SELECT Activated__c FROM Contact WHERE FirstName='First2'].get(0);
        
        System.assertEquals(true, acc.Activated__c, 'The account should be active');
        System.assertEquals(true, con1.Activated__c, 'The contact1 should be active');
        System.assertEquals(true, con2.Activated__c, 'The contact2 should be active');
        
        // update record
        Test.startTest();
        acc.Activated__c = false;
        update acc;
        Test.stopTest(); 
        
        // Get the latest records after update
        Contact contact1 = [SELECT Activated__c FROM Contact WHERE FirstName='First1'].get(0);        
        Contact contact2 = [SELECT Activated__c FROM Contact WHERE FirstName='First2'].get(0);
        
        // verify the behaviour
        System.assertEquals(false, acc.Activated__c, 'The account should not be active');
        System.assertEquals(false, contact1.Activated__c, 'The contact1 should not be active');
        System.assertEquals(false, contact2.Activated__c, 'The contact2 should not be active');
    }
    
    @isTest
    public static void updateAccountActiveContactsActive(){        
        // create account
        Account acc = new Account(Name='TestAccount', Activated__c=false);
        insert acc;
        
        // create contact
        Contact con1 = new Contact(FirstName='First1', LastName='Last1', AccountId=acc.Id,  Activated__c=false);
        insert con1;
        
        Contact con2 = new Contact(FirstName='First2', LastName='Last2', AccountId=acc.Id,  Activated__c=false);
        insert con2;
        // Verify initial values
        System.assertEquals(false, acc.Activated__c, 'The account should not be active');
        System.assertEquals(false, con1.Activated__c, 'The contact1 should not be active');
        System.assertEquals(false, con2.Activated__c, 'The contact2 should not be active');
        
        // update record
        Test.startTest();
        acc.Activated__c = true;
        update acc;
        Test.stopTest();
        
        // Get the latest records after update
        Contact contact1 = [SELECT Activated__c FROM Contact WHERE FirstName='First1'].get(0);        
        Contact contact2 = [SELECT Activated__c FROM Contact WHERE FirstName='First2'].get(0);
        
        // verify the behaviour
        System.assertEquals(true, acc.Activated__c, 'The account should be active');
        System.assertEquals(true, contact1.Activated__c, 'The contact1 should be active');
        System.assertEquals(true, contact2.Activated__c, 'The contact2 should be active');
    }
}