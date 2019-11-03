/**
 * @File Name          : CalculateHandler.cls
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 2/11/2019, 1:17:12 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/26/2019   shubhranshu     Initial Version
**/
public without sharing class CalculateHandler {
    
    public void AfterInsert(List<Item__c> lstItem , Map<Id,Item__c> newItemMap) {
        calculateTotalwithShippingAmount(lstItem,newItemMap);
    }

    public void AfterUpdate(List<Item__c> lstItem , Map<Id,Item__c> oldItemMap) {
        calculateTotalwithShippingAmount(lstItem,oldItemMap);
    }

    public void AfterDelete(List<Item__c> lstItem , Map<Id,Item__c> oldItemMap) {
        calculateTotalwithShippingAmount(lstItem,oldItemMap);
    }


    public void calculateTotalwithShippingAmount(List<Item__c> lst,Map<Id,Item__c> itemMap){
        
        System.debug('lst '+lst);
        
        List<Shipping_Invoice__c> lstshipInv =new List<Shipping_Invoice__c>();
        Set<Id> setOfShippInvId = new Set<Id>();
        Decimal totalPrice = 0.0;
        Decimal totalPound = 0.0;
        for(Item__c item : lst){
            setOfShippInvId.add(item.Shipping_Invoice__c);
        }
        System.debug('setOfShippInvId '+setOfShippInvId);
        List<Item__c> lstitem = [select Id ,Pound__c , Shipping_Invoice__c, Price__c from Item__c where Shipping_Invoice__c in : setOfShippInvId];

        System.debug('lstitem '+lstitem.size());
        for(Item__c item:lstitem){
           totalPound += item.Pound__c;
           totalPrice += item.Price__c;
        }
        
        lstshipInv = [select Id,Tax__c,Total_Price_for_all_items__c,Shipping__c,Total_pound_for_all_items__c,GrandTotal__c from Shipping_Invoice__c where Id in : setOfShippInvId];
        List<Shipping_Invoice__c> updateShipInvlst =new List<Shipping_Invoice__c>();

        for(Shipping_Invoice__c shiInv:lstshipInv){
            
            Decimal serviceTax = (shiInv.Tax__c);
            Decimal totalshipCharges = (totalPound * 75 ) /100;
            System.debug('serviceTax '+serviceTax +' totalPrice '+totalPrice +' totalPound '+totalPound +' totalshipCharges '+totalshipCharges);
            shiInv.Shipping__c = totalshipCharges ;
            shiInv.GrandTotal__c = serviceTax + (totalPrice) / 100 + totalshipCharges;
            System.debug('Total amount '+shiInv.GrandTotal__c);
            if(shiInv.GrandTotal__c < 100){
                shiInv.Shipping_Discount__c = 0.0;
            }
            updateShipInvlst.add(shiInv);
        }


        if(updateShipInvlst.size() > 0){
            System.debug('updateShipInvlst '+updateShipInvlst);
            try {
                update updateShipInvlst;
            } catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }
    }
}