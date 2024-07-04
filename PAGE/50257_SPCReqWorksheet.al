page 50257 "SPC Req. Worksheet"
{
    PageType = list;
    SourceTable = "Purchase Request Line";
    // Filter on the sales orders that are pending completion.
    SourceTableView = WHERE("Purchase Order No." = filter(''), "Vendor No." = filter(<> ''));
    AutoSplitKey = TRUE;
    ApplicationArea = All;
    UsageCategory = Administration;
    CaptionML = ENU = 'Purchase Request Work Sheet', FRA = 'Feuille demande achat';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;

                }
                field("Line no."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = FALSE;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
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
    actions
    {
        area(Processing)
        {

            //Defines action that display under the 'Actions' menu.
            action("Create Purchase Order")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = NewOrder;
                CaptionML = ENU = 'Create Purchase Order', FRA = 'Créer commande achat';
                trigger OnAction();
                begin
                    Subscribers.Worksheet_DA_ToOrder;
                end;
            }
            action("Create Purchase Quote")
            {
                ApplicationArea = All;
                //RunObject = page "Sales Quote";
                Promoted = true;
                PromotedCategory = Process;
                Image = NewOrder;
                Visible = false;
                CaptionML = ENU = 'Create Purchase Quote', FRA = 'Créer demande de prix';
                trigger OnAction();
                begin
                    //Consult.SetRequestNo(Rec);
                    //Consult.Run();
                end;
            }
        }
    }
    var
        Subscribers: Codeunit 50252;
        Consult: Report 50252;

}