pageextension 50262 PurchasesPayablesSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Posted Prepmt. Cr. Memo Nos.")
        {
            field("Purchase request No."; Rec."Purchase request No.")
            {
                ApplicationArea = all;
            }
            field("Update request Line From CA"; Rec."Update request Line From CA")
            {
                ApplicationArea = all;
            }
        }
    }
}