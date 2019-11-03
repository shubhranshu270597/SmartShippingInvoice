/**
 * @File Name          : RecommendItemHandler.cls
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 2/11/2019, 1:39:22 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   shubhranshu     Initial Version
**/
public without sharing class RecommendItemHandler {

    public void AfterInsert(List<Recommended_item__c> lstReItem , Map<Id,Recommended_item__c> newReItemMap) {
        checkforDiscountforRecItem(lstReItem,newReItemMap);
    }

    public void checkforDiscountforRecItem(List<Recommended_item__c> lst , Map<Id,Recommended_item__c> newMap){

        System.debug('lst '+lst);
        List<Shipping_Invoice__c> lstShipInv = new List<Shipping_Invoice__c>();
        Set<Id> setofShipInv = new Set<Id>();
        Map<Id,Decimal> mapofRIUnitPrice = new Map<Id,Decimal>();
        Map<Id,Decimal> mapofRIPound = new Map<Id,Decimal>();
        for(Recommended_item__c reitem:lst){
            setofShipInv.add(reitem.Shipping_Invoice__c);
            mapofRIUnitPrice.put(reitem.Shipping_Invoice__c, reitem.Unit_Price__c);
            mapofRIPound.put(reitem.Shipping_Invoice__c, reitem.Pound__c);
        }
        System.debug('setofShipInv '+setofShipInv);
        System.debug('mapofRIUnitPrice '+mapofRIUnitPrice);
        System.debug('mapofRIPound '+mapofRIPound);

        lstShipInv = [select Id,GrandTotal__c,Tax__c,Shipping__c from Shipping_Invoice__c where Id in : setofShipInv];
        List<Shipping_Invoice__c> updateShiInv = new List<Shipping_Invoice__c>();

        for(Shipping_Invoice__c si:lstShipInv){

            if(mapofRIUnitPrice.containsKey(si.Id) && mapofRIPound.containsKey(si.Id)){
                
                Decimal serviceTax = (si.Tax__c);
                Decimal totalshipCharges = (mapofRIPound.get(si.Id) * 75 ) /100;
                System.debug('serviceTax '+serviceTax +'totalshipCharges '+totalshipCharges);
                si.Shipping__c = si.Shipping__c !=null ? si.Shipping__c + totalshipCharges : totalshipCharges;
                si.GrandTotal__c = si.GrandTotal__c !=null ? si.GrandTotal__c + serviceTax + (mapofRIUnitPrice.get(si.Id)) / 100 + totalshipCharges : serviceTax + (mapofRIUnitPrice.get(si.Id)) / 100 + totalshipCharges;
                System.debug('Grand total '+si.GrandTotal__c);
                if(si.GrandTotal__c > 100){
                    System.debug('enter for discount..');
                    si.GrandTotal__c = si.GrandTotal__c - si.Shipping__c;
                    si.Shipping_Discount__c = si.Shipping__c;
                }
                
                updateShiInv.add(si);
            }
        }
        
        if(updateShiinv.size() > 0){
            System.debug('updateShiinv '+updateShiinv);
            try {
                update updateShiinv;
            } catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }
    }    
}