pageextension 50260 ExVendPostingGroups extends "Vendor Posting Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("Apply Stamp fiscal"; Rec."Apply Stamp fiscal")
            {
                ApplicationArea = all;
            }
            field("Stamp Fiscal Account"; Rec."Stamp Fiscal Account")
            {
                ApplicationArea = all;
            }
            field("Stamp fiscal Amount"; Rec."Stamp fiscal Amount")
            {
                ApplicationArea = all;
            }
            field("Activity obligation"; Rec."Activity obligation")
            {
                ApplicationArea = All;
            }

        }
    }
}