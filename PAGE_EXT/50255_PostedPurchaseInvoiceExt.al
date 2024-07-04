pageextension 50255 PostedPurchaseInvoiceExt extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Location Code")
        {
            group(TAXE)
            {
                field("Apply Stamp fiscal"; Rec."Apply Stamp fiscal")
                {
                    ApplicationArea = all;
                    Editable = FALSE;
                }
                field("Stamp fiscal Amount"; Rec."Stamp fiscal Amount")
                {
                    ApplicationArea = all;
                    Editable = FALSE;
                }
            }

        }
    }
}