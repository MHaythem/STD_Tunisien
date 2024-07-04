pageextension 50264 ItemCardExt extends "Item Card"
{
    layout
    {
        addafter("Base Unit of Measure")
        {
            field("Purchase Request Action Type"; Rec."Purch. Unit of Measure")
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