public with sharing class AccountsOperation {
    List<Account> currentAccounts;
    public AccountsOperation() {
        currentAccounts = new List<Account>();
    }
    public void getCurrentAccounts() {
        currentAccounts = [SELECT name,rating FROM Account];
        System.debug(currentAccounts);
    }
    public void insertMassAccounts() {
        Integer n = 150;
        List<Account> tempAccounts = new List<Account>();
         
        for(Integer index = 0; index < n; index++) {
            String sName = 'YLGrocery' + index;
            Account temp = new Account(name=sName,Industry='Retail');
            tempAccounts.add(temp);
        }
        Upsert(tempAccounts);
    }
    public void deleteMassAccounts() {
        List<Account> toDelete = [SELECT Id FROM Account WHERE name = '%YLGrocery%'];
        Delete toDelete;
    }

    public static Account insertNewAccount(String input) {
        Account newAcc = new Account(Name=input);
        List<Account> accList = new List<Account>();
        accList.add(newAcc);
        Database.SaveResult[] srList = Database.insert(accList, false);
        if(srList[0].isSuccess()) {
            newAcc.Id = srList[0].getId(); 
            return newAcc;
        } else {
            return null;
        }
    }

    public static List<Contact> searchForContacts(String lastN, String postC) {
        List<Contact> foundList = [SELECT Id,Name FROM Contact WHERE LastName = :lastN AND MailingPostalCode = :postC];
        return foundList;
    }

    
    // Public method
    public void sendMail(String address, String subject, String body) {
        // Create an email message object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        // Pass this email message to the built-in sendEmail method 
        // of the Messaging class
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                 new Messaging.SingleEmailMessage[] { mail });
        
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }
    
    // Helper method
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        
        return sendResult;
    }
}

