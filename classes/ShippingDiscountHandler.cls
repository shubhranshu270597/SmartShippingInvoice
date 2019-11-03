/**
 * @File Name          : ShippingDiscountHandler.cls
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 1/11/2019, 11:47:42 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   shubhranshu     Initial Version
**/
public without sharing class ShippingDiscountHandler {
    
    public static boolean isExecuting = false;
    
    public void AfterUpdate(List<Shipping_Invoice__c> lstShipInv , Map<Id,Shipping_Invoice__c> oldShipInvMap) {
        checkforDiscount(lstShipInv,oldShipInvMap);
    }

    public void checkforDiscount(List<Shipping_Invoice__c> lst,Map<Id,Shipping_Invoice__c> mapofOldShipInv){
        if( ShippingDiscountHandler.isExecuting ){
			return;
		}
		ShippingDiscountHandler.isExecuting = true; 

        System.debug('lst '+lst);
        List<Shipping_Invoice__c> updateShiinv = new List<Shipping_Invoice__c>();
        Decimal totalPrice = 0.0;
        List<Item__c> lstitem = [select Id ,Pound__c , Shipping_Invoice__c, Price__c from Item__c where Shipping_Invoice__c in : lst];
        System.debug('lstitem '+lstitem.size());
        for(Item__c item:lstitem){
           totalPrice += item.Price__c;
        }

        for(Shipping_Invoice__c shInv :lst){

            Decimal totalAmountindollar = totalPrice / 100;
            System.debug('totalAmountindollar '+totalAmountindollar);
            Shipping_Invoice__c SI = new Shipping_Invoice__c(Id = shInv.Id);
            if(totalAmountindollar > 100){
                SI.GrandTotal__c = shInv.GrandTotal__c - shInv.Shipping__c;
                SI.Shipping_Discount__c = shInv.Shipping__c;
            }
            System.debug('totalAmount '+SI.GrandTotal__c);
            updateShiinv.add(SI);
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