pageextension 50253 PurchaseInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        addafter("On Hold")
        {
            group(TAXE)
            {
                field("Apply Stamp fiscal"; Rec."Apply Stamp fiscal")
                {
                    ApplicationArea = all;
                }
                field("Stamp fiscal Amount"; Rec."Stamp fiscal Amount")
                {
                    ApplicationArea = all;
                }
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("Customer Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }
}