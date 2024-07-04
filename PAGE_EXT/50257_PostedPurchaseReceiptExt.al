pageextension 50257 PostedPurchaseReceiptExt extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Ship-to City")
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