({
    getItemList : function(component) {
        var shippIngInvoiceId = component.get('v.shippIngInvoiceId');
        var action = component.get('c.getAllItems');
        action.setParams({
            shippIngInvoiceId : shippIngInvoiceId
        })
        var self = this;
        action.setCallback(this, function (actionResult) {
            component.set('v.items', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    showShippingInvoice : function(component){
        var shippIngInvoiceId = component.get('v.shippIngInvoiceId');
        console.log(' shippIngInvoiceId ' + shippIngInvoiceId);
        
        var action = component.get('c.findByShippingInvoiceId');
        action.setParams({ 
            shippIngInvoiceId : shippIngInvoiceId 
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state '+state);
            
             if (state === 'SUCCESS') {
                var Object = response.getReturnValue();
                 console.dir('obj '+JSON.stringify(Object));                
                 component.set('v.shipinv', response.getReturnValue());
                 component.set('v.shiInvFound',true);
             }else if (state === "INCOMPLETE") {
                 alert('Response is Incompleted');
             }else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         alert("No match found !")
                     }
                 } else {
                     alert("Unknown error");
                 }
             }
        });
        $A.enqueueAction(action);
    }
})