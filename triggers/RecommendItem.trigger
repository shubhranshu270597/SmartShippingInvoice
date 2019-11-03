/**
 * @File Name          : RecommendItem.trigger
 * @Description        : 
 * @Author             : shubhranshu
 * @Group              : 
 * @Last Modified By   : shubhranshu
 * @Last Modified On   : 28/10/2019, 7:47:04 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   shubhranshu     Initial Version
**/
trigger RecommendItem on Recommended_item__c (after insert) {
    
    if(trigger.isAfter && trigger.isInsert)
    {
        RecommendItemHandler obj = new RecommendItemHandler();
        obj.AfterInsert(trigger.new, trigger.newMap);
    }
}