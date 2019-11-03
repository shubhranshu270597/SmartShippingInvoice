({
    Search: function (component, event) {
        var customerRegNo = component.get('v.customerRegNo');
        console.log(' customerRegNo ' + customerRegNo);
        
        var action = component.get('c.findByCustomerId');
        action.setParams({ customerRegNo: customerRegNo });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state '+state);
            
            if (state === 'SUCCESS') {
                var Object = response.getReturnValue();
                console.dir('obj '+JSON.stringify(Object));                
                component.set('v.cust', response.getReturnValue());
                component.set('v.customerFound',true);
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // alert("Error message: " + 
                        //             errors[0].message);
                        alert("No match found , please try with different registration no. !")
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    doInit : function(component,event , helper){
        var action = component.get('c.getAllRecommItems');
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state '+state);
            
            if (state === 'SUCCESS') {
                var Object = response.getReturnValue();
                console.dir('obj '+JSON.stringify(Object));                
                component.set('v.reitem', response.getReturnValue());
                component.set('v.reitemFound',true);
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // alert("Error message: " + 
                        //             errors[0].message);
                        alert("No Record exist!")
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);

    },

    addReitem : function(component,event,helper){
        var shippIngInvoiceId = component.get('v.shippIngInvoiceId');
        var reitemId = event.target.getElementsByClassName('reitem-id')[0].value;

        var reitemName = event.target.getElementsByClassName('reitem-name')[0].value;
        var confirmForDelete = confirm('Add the ' + reitemName + ' Item ?');
        if (confirmForDelete == true) {
            var action = component.get('c.addReItem');
            action.setParams({
                shippIngInvoiceId : shippIngInvoiceId,
                reitemId: reitemId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state ' + state);
                if (state === 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log('Result' + result);
                    alert(result);
                } else if (state == "ERROR") {
                    let errors = response.getError();
                    let message;
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message;
                    }
                    alert(message);
                }
            });
        }
        event.preventDefault();    
        $A.enqueueAction(action);
        helper.showShippingInvoice(component);
    },
    generateShippingInvoice: function (component, event,helper){
       
        var customerRegNo = component.get('v.customerRegNo');
        console.log(' customerRegNo ' + customerRegNo);

        var action = component.get('c.insertShippingInvoice');
        action.setParams({ customerRegNo: customerRegNo });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state ' + state);

            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('Result' + result);
                component.set('v.shippIngInvoiceId', response.getReturnValue());
                component.set('v.shiInvInsert', true);
                alert("Shipping invoice generated !");
            } else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Sorry, shipping invoice not generate !")
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    generateNewItem: function(component , event , helper){
        var item = component.get('v.item');
        var shippIngInvoiceId = component.get('v.shippIngInvoiceId');
        if (item.Item_name__c == '') {
            alert('Please enter the item name');
            return false;
        }
        if (item.Pound__c == null) {
            alert('Please enter the pound');
            return false;
        }
        if (item.Quantity__c == null) {
            alert('Please enter the item quantity');
            return false;
        }
        if (item.Price__c == null) {
            alert('Please enter the item price');
            return false;
        }

        var action = component.get('c.createItemRecord');
        action.setParams({
            item : item,
            shippIngInvoiceId: shippIngInvoiceId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS"){
                var newitem = {
                    'sobjectType': 'Item__c', 'Item_name__c': '',
                    'Pound__c': '', 'Quantity__c': '', 'Unit_Price__c': ''
                };
            component.set('v.item', newitem);
            component.set('v.itemInsert' , true);
            alert('Item is Created Sucessfully');           
            } else if (state == "ERROR") {
                let errors = response.getError();
                let message;
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                alert(message);
            }
    });
        $A.enqueueAction(action);
        helper.getItemList(component);
        helper.showShippingInvoice(component);
    },
    // showItems: function (component, event, helper) {
    //     helper.getItemList(component);
    // },

    deleteItem: function (component, event, helper) {
        event.preventDefault();
        var itemId = event.target.getElementsByClassName('item-id')[0].value;
        var itemName = event.target.getElementsByClassName('item-name')[0].value;
        var confirmForDelete = confirm('Delete the ' + itemName + ' Item ?');
        if (confirmForDelete == true) {
            var action = component.get('c.deleteitem');
            action.setParams({
                itemId: itemId
            })

            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state ' + state);
                if (state === 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log('Result' + result);
                    alert(result);
                } else if (state == "ERROR") {
                    let errors = response.getError();
                    let message;
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message;
                    }
                    alert(message);
                }
            });
        }
        $A.enqueueAction(action);
        helper.showShippingInvoice(component);
        helper.getItemList(component);
    },
    editItem: function (component, event, helper) {
        
        var itemId = event.target.getElementsByClassName('item-id')[0].value;
        var itemName = event.target.getElementsByClassName('item-name')[0].value;
        console.log('a target id'+itemId);
        
        if (confirm('Are you sure to update '+ itemName +' ?')){
            component.set('v.isEdit', true);
            component.set('v.editItemId', itemId);
        }
    },
    // save: function (component, event, helper) {
    //     var editItemId = component.get('v.editItemId');
    //     console.log('editItem id '+editItemId);
        
    //     try {
    //         component.find('editItem').get('e.recordSave').fire();
    //         component.set('v.isEdit', false);
    //         alert('updated successfully...');
    //     } catch (e) {
    //         console.log(e);
    //     } 
    //    // location.reload();// This will refresh the app to get the latest updated data.        
    // },

    handleSuccess: function (cmp, event, helper) {
        cmp.set('v.isEdit', false);
        alert('Updated Successfully.');
        helper.showShippingInvoice(cmp);
        helper.getItemList(cmp);
    },

    handleError: function (cmp, event, helper) {
        cmp.set('v.isEdit', false);
        alert('Failed to updated.');
    }

})