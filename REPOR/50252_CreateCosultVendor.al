report 50252 CreateConsultVendor
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = TRUE;
    DefaultLayout = RDLC;
    RDLCLayout = 'CreateConsultVendor.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                PurchSetup.GET;
                PurchSetup.TESTFIELD("Quote Nos.");
                PurchReqLine.RESET;
                PurchReqLine.SETRANGE("Request No.", RequestHeader."No.");
                PurchReqLine.SetRange("Purchase Order No.", '');
                PurchReqLine.SetRange("Purchase Order Line No.", 0);
                PurchReqLine.SetRange("Accept Action Message", true);
                PurchReqLine.SetRange("Action Type", PurchReqLine."Action Type"::"Purchase Quote");
                IF NOT PurchReqLine.IsEmpty then begin
                    PurchHeader.INIT;
                    PurchHeader.VALIDATE("Document Type", OrderType);
                    PurchHeader."No." := '';
                    PurchHeader."Posting Date" := TODAY;
                    PurchHeader.INSERT(TRUE);
                    PurchHeader."Order Date" := TODAY;
                    PurchHeader.VALIDATE("Buy-from Vendor No.", "No.");
                    PurchHeader."Purchase Request No." := RequestHeader."No.";
                    PurchHeader.VALIDATE("Shortcut Dimension 1 Code", RequestHeader."Shortcut Dimension 1 Code");
                    PurchHeader.VALIDATE("Shortcut Dimension 2 Code", RequestHeader."Shortcut Dimension 2 Code");
                    PurchHeader.MODIFY(TRUE);
                    //Window.UPDATE(1, PurchHeader."No.");
                    Subscribers.InsertLineOrder(RequestHeader, PurchHeader);
                    //MESSAGE(Text003, PurchOrderHeader."No.", PurchOrderHeader."Buy-from Vendor No.");
                end else
                    ERROR('Rien à commender!!')
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }
    var
        PurchSetup: Record 312;
        PurchHeader: Record 38;
        RequestHeader: Record 50251;
        PurchReqLine: Record 50252;
        Subscribers: Codeunit 50252;
        OrderType: Integer;
        Window: Dialog;
        Text001: TextConst ENU = 'Create Purchase Quote', FRA = 'Création demande de prix';

    procedure SetRequestNo(PRequestHeader: record 50251; PorderType: Integer)
    var
    begin
        RequestHeader := PRequestHeader;
        OrderType := PorderType;
    end;
}