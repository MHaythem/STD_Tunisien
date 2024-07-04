pageextension 50251 VendorCardExt extends "Vendor Card"
{
    layout
    {
        addafter("Vendor Posting Group")
        {
            group(TAXE)
            {
                field("Apply Stamp fiscal"; Rec."Apply Stamp fiscal")
                {
                    ApplicationArea = all;

                }
            }

        }

        addlast(General)
        {
            field(Activity; Rec.Activity)
            {
                ApplicationArea = All;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = all;
                editable = false;
            }
        }

    }
    actions
    {
        // Add changes to page actions here
        addlast("Request Approval")
        {
            action(Reopen)
            {
                CaptionML = ENU = 'Reopen', FRA = 'Rouvrir';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Image = ReOpen;

                trigger OnAction()
                begin
                    Rec.validate(Status, Rec.Status::Open);
                    Rec.Modify;
                end;
            }
        }
    }
    // trigger OnAfterGetCurrRecord()
    // var
    //     myInt: Integer;
    // begin
    //     Edit := false;
    //     if Rec.Status = Rec.Status::Open then
    //         Edit := true;
    // end;

    var
        Edit: Boolean;
}