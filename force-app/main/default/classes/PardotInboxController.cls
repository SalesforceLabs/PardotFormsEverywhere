public with sharing class PardotInboxController {

    @AuraEnabled
    public static List<Person> getRelatedPeople(List<String> emailAddresses){
        List<Person> people = new List<Person>();
        List<Person> peopleFromContacts = getRelatedContactRecords(emailAddresses);
        List<Person> peopleFromLead = getRelatedLeadRecords(emailAddresses);
        people.addAll(peopleFromContacts);
        people.addAll(peopleFromLead);
        return people;
    }

    public static List<Person> getRelatedContactRecords(List<String> emailAddresses){
        List<Contact> contacts = Database.query('SELECT Id, Name, Email, pi__score__c, pi__Pardot_Last_Scored_At__c, pi__created_date__c FROM Contact WHERE Email IN: emailAddresses WITH SECURITY_ENFORCED');
        List<Person> people = new List<Person>();
        for (Contact contact : contacts) {
            Person person = new Person();
            person.PersonId = contact.Id;
            person.SObjectType = 'Contact';
            person.Name = contact.Name;
            person.Email = contact.Email;
            person.Score = (Decimal) contact.get('pi__score__c'); 
            person.ScoreUpdated = (Datetime) contact.get('pi__Pardot_Last_Scored_At__c');
            person.PardotCreatedDate = (Datetime) contact.get('pi__created_date__c');
            people.add(person);
            system.debug(person);
        }
        return people;
    }

    public static List<Person> getRelatedLeadRecords(List<String> emailAddresses){
        List<Lead> leads = Database.query('SELECT Id, Name, Email, pi__score__c, pi__Pardot_Last_Scored_At__c, pi__created_date__c FROM Lead WHERE IsConverted = false AND Email IN: emailAddresses WITH SECURITY_ENFORCED');
        List<Person> people = new List<Person>();
        for (Lead lead : leads) {
            Person person = new Person();
            person.PersonId = lead.Id;
            person.SObjectType = 'Lead';
            person.Name = lead.Name;
            person.Email = lead.Email;
            person.Score = (Decimal) lead.get('pi__score__c'); 
            person.ScoreUpdated = (Datetime) lead.get('pi__Pardot_Last_Scored_At__c');
            person.PardotCreatedDate = (Datetime) lead.get('pi__created_date__c');
            people.add(person);
            system.debug(person);
        }
        return people;
    }

    public class Person {
        @AuraEnabled
        public Id PersonId { get; set; }
        @AuraEnabled
        public String SObjectType { get; set; }
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public String Email { get; set; }
        @AuraEnabled
        public Decimal Score { get; set; }
        @AuraEnabled
        public Datetime ScoreUpdated { get; set; }
        @AuraEnabled
        public Datetime PardotCreatedDate { get; set; }
      }
    
}