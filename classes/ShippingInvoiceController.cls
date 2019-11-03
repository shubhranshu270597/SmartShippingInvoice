/**
 * @File Name          : ShippingInvoiceController.cls
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 11/2/2019, 5:50:12 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    29/10/2019   shubhranshu     Initial Version
**/
public without sharing class ShippingInvoiceController {
    
    @AuraEnabled
    public static Customer__c findByCustomerId( String customerRegNo){
        System.debug('customerRegNo in findByCustomerId '+customerRegNo);
        return  [SELECT id, Address__c, Customer_email__c, Customer_mobile__c, Name 
                  FROM Customer__c WHERE Customer_reg_no__c = :customerRegNo limit 1];
    }

    @AuraEnabled
    public static Shipping_Invoice__c findByShippingInvoiceId( String shippIngInvoiceId){
        System.debug('ShippingInvoiceId in findByCustomerId '+ShippingInvoiceId);
        return  [SELECT id, Tax__c, Shipping_Address__c, Shipping__c ,GrandTotal__c,Shipping_Discount__c,Total_pound_for_all_items__c,Total_Price_for_all_items__c
                  FROM Shipping_Invoice__c WHERE id = :shippIngInvoiceId limit 1];
    }

    @AuraEnabled
    public static Id insertShippingInvoice(String customerRegNo){
        System.debug('customerRegNo in insert SI '+customerRegNo);
        // String message = '';
        Id custId = null;
        Id ShipInvId = null;
        Customer__c cust = [Select Id from Customer__c where Customer_reg_no__c =: customerRegNo];

        if(cust !=null){
            custId = cust.Id;
        }

        if(custId != null){
            Shipping_Invoice__c si = new Shipping_Invoice__c();
            si.Customer__c = custId;

            try {
                insert si;
         //       message = 'Shipping invoice generated !';
                ShipInvId = si.Id;
            } catch (DmlException e) {
                System.debug('error '+e.getMessage());
           //     message = e.getMessage();
            }
        }

        return ShipInvId;
    }

    @AuraEnabled
    public static Item__c createItemRecord(Item__c item,String shippIngInvoiceId){
        
        // item.Shipping_Invoice__c = shippIngInvoiceId;

        Item__c it= item.clone();

        it.Shipping_Invoice__c = shippIngInvoiceId;

        try{    
            insert it;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
        return it;
    }

    @AuraEnabled
    public static List <Item__c> getAllItems(String shippIngInvoiceId) {
        System.debug('shippIngInvoiceId in getAllItems '+shippIngInvoiceId);
        return [SELECT Id, Item_name__c, Pound__c, Quantity__c, 
                Price__c FROM Item__c where Shipping_Invoice__c =:shippIngInvoiceId 
                ORDER BY createdDate ASC];
    }

    @AuraEnabled
    public static String deleteitem (String itemId){
        String msg = '';
        System.debug('itemId in delete item '+itemId);
        Item__c it= [select Id from Item__c where Id =: itemId limit 1];
        try {
            delete it;
            msg = 'item deleted successfully!'; 
        } catch (DmlException e) {
            System.debug(e.getMessage());
            msg = e.getMessage();
        }
        return msg;
    }

    @AuraEnabled
    public static List<Recommended_item__c> getAllRecommItems(){
        List<Recommended_item__c> lstRI = [select Id,Reitem_Name__c,Unit_Price__c,Shipping_Invoice__c, Pound__c,Quantity__c from Recommended_item__c limit 50];
        return checkDuplicateRecommendedItem(lstRI);
    }

    @AuraEnabled
    public static String addReItem(String shippIngInvoiceId,String reitemId){
        
        System.debug('shippIngInvoiceId '+shippIngInvoiceId+' reitemId '+ reitemId);
        String msg = '';
        Recommended_item__c ritem  = new Recommended_item__c();
        List<Recommended_item__c> rilst = [select Id,Reitem_Name__c,Unit_Price__c,Shipping_Invoice__c, Pound__c,Quantity__c from Recommended_item__c where Id =:reitemId limit 1];
        if(rilst.size() > 0){
            
            for(Recommended_item__c ri:rilst){
                ritem = ri.clone();
                ritem.Shipping_Invoice__c = shippIngInvoiceId;
            }

            try{
            insert ritem;
                msg = 'Recommended item added !';
            }catch(DmlException e){
                System.debug(e.getMessage());
                msg = e.getMessage();
            }
        }else{
            msg = 'Record not found';
        }
          return msg;
    }

    public static List<Recommended_item__c> checkDuplicateRecommendedItem(List<Recommended_item__c> lst){
        List<Recommended_item__c> lstofuniqueRi= new List<Recommended_item__c>();
        Set<String> setofitemName = new Set<String>(); 

        if(lst.size() > 0){
            for(Recommended_item__c r:lst){
                if(!setofitemName.contains(r.Reitem_Name__c)){
                    setofitemName.add(r.Reitem_Name__c);
                    lstofuniqueRi.add(r);
                }
            }   
        }
        return lstofuniqueRi;
    }
}