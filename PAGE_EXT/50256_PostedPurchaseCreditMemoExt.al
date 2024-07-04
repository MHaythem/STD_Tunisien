pageextension 50256 PostedPurchaseCreditMemoExt extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Applies-to Doc. No.")
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