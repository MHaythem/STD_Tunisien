pageextension 50258 PurchaseQuoteExt extends "Purchase Quote"
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
                }
                field("Stamp fiscal Amount"; Rec."Stamp fiscal Amount")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}