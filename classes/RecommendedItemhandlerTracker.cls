/**
 * @File Name          : RecommendedItemhandlerTracker.cls
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 1/11/2019, 11:51:28 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   shubhranshu     Initial Version
**/
@isTest(seeAllData = false)
public with sharing class RecommendedItemhandlerTracker {
    
    @testSetup
    public static void setUpData(){
        
        Customer__c cust = new Customer__c();
        cust.Customer_email__c = 'tttt@gmail.com';
        cust.Customer_mobile__c = '9848691545';
        cust.Address__c = 'test';
        insert cust;

        Shipping_Invoice__c si = new Shipping_Invoice__c();
        si.Tax__c = 9.25;
        si.Shipping_Address__c = 'sss , mumbai';
        si.Customer__c = cust.Id;
        insert si;

        Recommended_item__c  reitem1 = new Recommended_item__c();
        reitem1.Reitem_Name__c = 'xxxx';
        reitem1.Pound__c = 1.3;
        reitem1.Quantity__c = 1;
        reitem1.Shipping_Invoice__c = si.Id;
        reitem1.Unit_Price__c = 500.00;
        insert reitem1;
    }

    static testMethod void testCheckDiscount(){
        Recommended_item__c reitem = [select id ,Shipping_Invoice__c , Unit_Price__c , Pound__c from Recommended_item__c limit 1];
        List<Recommended_item__c> lst = new List<Recommended_item__c>();
        Map<Id,Recommended_item__c> newMap = new Map<Id,Recommended_item__c>();
        lst.add(reitem);
        newMap.put(reitem.Id, reitem);
        test.startTest();
        RecommendItemHandler obj = new RecommendItemHandler();
        obj.AfterInsert(lst, newMap);
        test.stopTest(); 
    }
}