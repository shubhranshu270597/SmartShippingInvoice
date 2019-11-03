<aura:application extends="force:slds">
    <link href='/resource/bootstrap/' rel="stylesheet" />
    <div class="navbar navbar-default navbar-static-top" role="navigation" style="background-color: indigo;">
        <div class="container">
            <div class="navbar-header">
                <a href="#" class="navbar-brand">SMART SHIPPING INVOICE</a>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-sm-12">
                <c:ShippingInvoiceComp />
            </div>
        </div>
    </div>
</aura:application>