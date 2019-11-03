/**
 * @File Name          : ShippingInvoiceControllerTracker.cls
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 11/2/2019, 5:43:38 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/2/2019   shubhranshu     Initial Version
**/
@isTest(seeAllData = false)
public without sharing class ShippingInvoiceControllerTracker {
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

        Recommended_item__c  reitem1 = new Recommended_item__c();
        reitem1.Reitem_Name__c = 'xxxx';
        reitem1.Pound__c = 1.3;
        reitem1.Quantity__c = 1;
        reitem1.Shipping_Invoice__c = si.Id;
        reitem1.Unit_Price__c = 500.00;
        insert reitem1;
    }

    static testMethod void testCheckDiscount(){
        Customer__c c  = [SELECT id, Address__c, Customer_email__c, Customer_mobile__c, Name,Customer_reg_no__c from Customer__c  limit 1];
        Shipping_Invoice__c s= [SELECT id, Tax__c, Shipping_Address__c, Shipping__c ,GrandTotal__c,Shipping_Discount__c,Total_pound_for_all_items__c,Total_Price_for_all_items__c from Shipping_Invoice__c limit 1];

        Test.startTest();
        ShippingInvoiceController.findByCustomerId(c.Customer_reg_no__c);
        ShippingInvoiceController.findByShippingInvoiceId(s.id);
        ShippingInvoiceController.insertShippingInvoice(c.Customer_reg_no__c);

        Item__c item = new Item__c();
        item.Item_name__c = 'sss';
        item.Pound__c = 3.3;
        item.Quantity__c = 1;
        item.Shipping_Invoice__c = s.Id;
        item.Price__c = 200.00;
        insert item;

        Recommended_item__c  reitem1 = [select id , Reitem_Name__c from Recommended_item__c limit 1];
        List<Recommended_item__c> lst = new List<Recommended_item__c>();
        lst.add(reitem1);

        ShippingInvoiceController.createItemRecord(item,s.Id);
        ShippingInvoiceController.getAllItems(s.Id);
        ShippingInvoiceController.deleteitem(item.Id);
        ShippingInvoiceController.getAllRecommItems();
        ShippingInvoiceController.addReItem(s.Id,reitem1.Id);
        ShippingInvoiceController.checkDuplicateRecommendedItem(lst);

        Test.stopTest();
    }

}