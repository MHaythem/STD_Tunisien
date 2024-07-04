pageextension 50285 "Inventory Setup EXT" extends "Inventory Setup"
{
    layout
    {
        addafter("Location Mandatory")
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}