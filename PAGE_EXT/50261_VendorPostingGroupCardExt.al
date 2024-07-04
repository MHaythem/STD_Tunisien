pageextension 50261 ExVendorPostingGroup extends "Vendor Posting Group Card"
{
    layout
    {
        addafter("Payment Tolerance Credit Acc.")
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