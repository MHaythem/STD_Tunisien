pageextension 50263 BusinessManagerRoleCenterExt extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addbefore("<Page Purchase Orders>")
        {

            action("Purchase Request")
            {
                //AccessByPermission = TableData "Purchase Header" = IMD;
                ApplicationArea = all;
                CaptionML = ENU = 'Purchase Request', FRA = 'Demandes achat';
                Image = NewSalesQuote;
                RunObject = Page "PurchaseRequestList";
                RunPageMode = Create;
                ToolTip = 'Create a new purchase request.';
            }
        }
    }

    var
        myInt: Integer;
}