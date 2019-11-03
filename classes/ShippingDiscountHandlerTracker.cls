/**
 * @File Name          : ShippingDiscountHandlerTracker.cls
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 2/11/2019, 2:00:12 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   shubhranshu     Initial Version
**/
@isTest(seeAllData = false)
public without sharing class ShippingDiscountHandlerTracker {
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

        Item__c item1 = new Item__c();
        item1.Item_name__c = 'xyz1';
        item1.Pound__c = 1.3;
        item1.Quantity__c = 1;
        item1.Shipping_Invoice__c = si.Id;
        item1.Price__c = 500.00;
        insert item1;

        Item__c item2 = new Item__c();
        item2.Item_name__c = 'xyz2';
        item2.Pound__c = 3.3;
        item2.Quantity__c = 1;
        item2.Shipping_Invoice__c = si.Id;
        item2.Price__c = 200.00;
        insert item2;

        Item__c item3 = new Item__c();
        item3.Item_name__c = 'xyz3';
        item3.Pound__c = 2.3;
        item3.Quantity__c = 1;
        item3.Shipping_Invoice__c = si.Id;
        item3.Price__c = 100.00;
        insert item3; 
    }

    static testMethod void testCheckDiscount(){
        Shipping_Invoice__c s= [select id , Shipping_Address__c from Shipping_Invoice__c limit 1];
        Test.startTest();
        s.Shipping_Address__c = 'tetsst';
        update s;
        Test.stopTest();
    }
}