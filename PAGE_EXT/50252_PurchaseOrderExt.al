pageextension 50252 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field(WorkDescription; WorkDescription)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Work description', FRA = 'Commentaires';
                Importance = Additional;
                MultiLine = true;
                ShowCaption = true;

                trigger OnValidate()
                begin
                    Rec.SetWorkDescription(WorkDescription);
                end;
            }
        }
        addafter("Promised Receipt Date")
        {
            group(TAXE)
            {
                field("Apply Stamp fiscal"; Rec."Apply Stamp fiscal")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Stamp fiscal Amount"; Rec."Stamp fiscal Amount")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
            }
        }
    }
    actions
    {
        modify(Print)
        {
            Enabled = rec.Status = Rec.Status::Released;
        }
        modify("&Print")
        {
            Enabled = rec.Status = Rec.Status::Released;
        }
    }
    var

        WorkDescription: Text;
}

