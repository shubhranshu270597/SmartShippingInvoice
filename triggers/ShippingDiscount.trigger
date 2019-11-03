/**
 * @File Name          : ShippingDiscount.trigger
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 28/10/2019, 1:04:16 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   shubhranshu     Initial Version
**/
trigger ShippingDiscount on Shipping_Invoice__c (after update) {
   
    if(trigger.isAfter && trigger.isUpdate)
    {          
        ShippingDiscountHandler obj = new ShippingDiscountHandler();
        obj.AfterUpdate(trigger.new, trigger.oldMap);
    }
}