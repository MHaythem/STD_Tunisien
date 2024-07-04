page 50252 "PurchaseRequestLine"
{
    PageType = ListPart;
    SourceTable = "Purchase Request Line";
    // Filter on the sales orders that are pending completion.
    //SourceTableView = WHERE("Completely Shipped" = CONST(False));
    AutoSplitKey = TRUE;
    CaptionML = ENU = 'Purchase Request Line', FRA = 'Lignes demande achat';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("Line no."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = FALSE;
                    Editable = FALSE;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ValuesAllowed = 0, 2, 4, 5;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                }

                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name 2"; Rec."Vendor Name 2")
                {
                    ApplicationArea = All;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Accept Action Message"; Rec."Accept Action Message")
                {
                    ApplicationArea = All;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }

    }
}