/**
 * @File Name          : Calculate.trigger
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 28/10/2019, 1:02:29 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/26/2019   shubhranshu     Initial Version
**/
trigger Calculate on Item__c (after insert,after update, after delete) {
    if(trigger.isAfter && trigger.isInsert)
    {
        CalculateHandler obj = new CalculateHandler();
        obj.AfterInsert(trigger.new, trigger.newMap);
    }
    if(trigger.isAfter && trigger.isUpdate)
    {          
        CalculateHandler obj = new CalculateHandler();
        obj.AfterUpdate(trigger.new, trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isDelete)
    {        
        CalculateHandler obj = new CalculateHandler();
        obj.AfterDelete(trigger.old, trigger.oldMap);
    }
}