tableextension 50253 "Invetory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        field(5; "Location Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Location Code';
            TableRelation = Location;

        }
    }

    var
        myInt: Integer;
}