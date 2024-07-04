codeunit 50252 Subscribers
{
    [EventSubscriber(ObjectType::Table, 23, 'OnAfterValidateEvent', 'Vendor Posting Group', TRUE, TRUE)]
    procedure OnAfterValidateEventVendorPostingGroup(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    Var
        VendorPostingGroup: Record 93;
    begin
        IF Rec."Vendor Posting Group" <> xRec."vendor Posting Group" THEN BEGIN
            VendorPostingGroup.RESET;
            VendorPostingGroup.GET(Rec."Vendor Posting Group");
            Rec."Apply Stamp fiscal" := VendorPostingGroup."Apply Stamp fiscal";
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Customer Posting Group', TRUE, TRUE)]
    procedure OnAfterValidateEventCustomerPostingGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    Var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        IF Rec."Customer Posting Group" <> xRec."Customer Posting Group" THEN BEGIN
            CustomerPostingGroup.RESET;
            CustomerPostingGroup.GET(Rec."Customer Posting Group");
            Rec."Apply Stamp fiscal" := CustomerPostingGroup."Apply Stamp fiscal";
        END;
    end;


    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Pay-to Vendor No.', TRUE, TRUE)]
    procedure AfterOnValidatePurchaseHeaderBillToCustomerNo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    VAR
        lVendor: Record 23;
        lVendorPostingGroup: Record 93;

    begin
        IF lVendor.GET(Rec."Pay-to Vendor No.") THEN BEGIN
            lVendorPostingGroup.GET(lVendor."Vendor Posting Group");
            Rec."Apply Stamp fiscal" := lVendor."Apply Stamp fiscal";
            Rec."Stamp fiscal Amount" := lVendorPostingGroup."Stamp fiscal Amount";
        END;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Apply Stamp fiscal', TRUE, TRUE)]
    procedure AfterOnValidatePurchaseHeaderApplyStampfiscal(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    VAR
        lVendorPostingGroup: Record 93;
    begin
        if Rec."Apply Stamp fiscal" <> xRec."Apply Stamp fiscal" then begin
            lVendorPostingGroup.GET(Rec."Vendor Posting Group");
            if Rec."Apply Stamp fiscal" then
                Rec."Stamp fiscal Amount" := lVendorPostingGroup."Stamp fiscal Amount"
            else
                Rec."Stamp fiscal Amount" := 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Vendor Posting Group', TRUE, TRUE)]
    procedure AfterOnValidatePurchaseHeaderVendorPostingGroupl(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    VAR
        lVendorPostingGroup: Record 93;
    begin
        IF lVendorPostingGroup.GET(Rec."Vendor Posting Group") THEN BEGIN
            Rec."Apply Stamp fiscal" := lVendorPostingGroup."Apply Stamp fiscal";
            Rec."Stamp fiscal Amount" := lVendorPostingGroup."Stamp fiscal Amount";
        end;
    end;

    // timbre Vente


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Bill-to Customer No.', TRUE, TRUE)]
    procedure AfterOnValidateSalesHeaderBillToCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    VAR
        customer: Record Customer;
        Custpostinggroup: Record "Customer Posting Group";

    begin
        IF customer.GET(Rec."Bill-to Customer No.") THEN BEGIN
            Custpostinggroup.GET(customer."customer Posting Group");
            Rec."Apply Stamp fiscal" := customer."Apply Stamp fiscal";
            Rec."Stamp fiscal Amount" := Custpostinggroup."Stamp fiscal Amount";
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Apply Stamp fiscal', TRUE, TRUE)]
    procedure AfterOnValidateSalesHeaderApplyStampfiscal(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    VAR
        custpostinggroup: Record "Customer Posting Group";
    begin
        if Rec."Apply Stamp fiscal" <> xRec."Apply Stamp fiscal" then begin
            custpostinggroup.GET(Rec."Customer Posting Group");
            if Rec."Apply Stamp fiscal" then
                Rec."Stamp fiscal Amount" := custpostinggroup."Stamp fiscal Amount"
            else
                Rec."Stamp fiscal Amount" := 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Customer Posting Group', TRUE, TRUE)]
    procedure AfterOnValidateSalesHeaderCustPostingGroupe(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    VAR
        Custpostinggroup: Record "Customer Posting Group";
    begin
        IF Custpostinggroup.GET(Rec."Customer Posting Group") THEN BEGIN
            Rec."Apply Stamp fiscal" := Custpostinggroup."Apply Stamp fiscal";
            Rec."Stamp fiscal Amount" := Custpostinggroup."Stamp fiscal Amount";
        end;
    end;

    // Propagation Info Dossier Transit

    // Compta Timbre Achat
    procedure PurchPostTimbre(VAR PurchaseHeader: Record "Purchase Header"; GenJnlPostLine: Codeunit 12; GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record 81;
        SourceCodeSetup: Record "Source Code Setup";
        VendorPostingGroup: Record "Vendor Posting Group";
        SrcCode: code[10];
        CompteTimbre: Code[20];
        MntTimbre: Decimal;
    begin

        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.Sales;

        VendorPostingGroup.GET(PurchaseHeader."Vendor Posting Group");
        IF PurchaseHeader."Apply Stamp Fiscal" THEN BEGIN
            VendorPostingGroup.TestField("Apply Stamp Fiscal"); //            
            VendorPostingGroup.TESTFIELD("Stamp Fiscal Account");
            VendorPostingGroup.TESTFIELD("Stamp Fiscal Amount"); //

            MntTimbre := 0;
            MntTimbre := VendorPostingGroup."Stamp Fiscal Amount";
            CompteTimbre := VendorPostingGroup."Stamp Fiscal Account";

            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := PurchaseHeader."Posting Date";
            GenJnlLine."Document Date" := PurchaseHeader."Document Date";
            GenJnlLine.Description := PurchaseHeader."Posting Description";
            GenJnlLine."Shortcut Dimension 1 Code" := PurchaseHeader."Shortcut Dimension 1 Code"; //
            GenJnlLine."Shortcut Dimension 2 Code" := PurchaseHeader."Shortcut Dimension 2 Code"; //
            GenJnlLine."Reason Code" := GenJnlLine."Reason Code"; //
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := CompteTimbre;
            GenJnlLine."Document Type" := GenJournalLine."Document Type";
            GenJnlLine."Document No." := GenJournalLine."Document No.";
            GenJnlLine."External Document No." := GenJournalLine."External Document No.";
            GenJnlLine."Currency Code" := GenJnlLine."Currency Code"; //FIXME:
            GenJnlLine.Amount := MntTimbre;
            GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
            GenJnlLine."Source Currency Amount" := MntTimbre;
            GenJnlLine."Amount (LCY)" := MntTimbre;
            IF PurchaseHeader."Currency Code" = '' THEN
                GenJnlLine."Currency Factor" := 1
            ELSE
                GenJnlLine."Currency Factor" := PurchaseHeader."Currency Factor";
            GenJnlLine.Correction := GenJnlLine.Correction; //FIXME:
            GenJnlLine."Sales/Purch. (LCY)" := 0;
            GenJnlLine."Profit (LCY)" := 0;
            GenJnlLine."Inv. Discount (LCY)" := 0;
            GenJnlLine."Sell-to/Buy-from No." := PurchaseHeader."Buy-from Vendor No.";
            GenJnlLine."Bill-to/Pay-to No." := PurchaseHeader."Pay-to Vendor No.";
            GenJnlLine."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."On Hold" := GenJnlLine."On Hold"; //
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"; //
            GenJnlLine."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No."; //
            GenJnlLine."Applies-to ID" := GenJnlLine."Applies-to ID"; //
            GenJnlLine."Allow Application" := GenJnlLine."Bal. Account No." = '';
            GenJnlLine."Due Date" := GenJnlLine."Due Date"; //
            GenJnlLine."Payment Terms Code" := GenJnlLine."Payment Terms Code"; //
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
            GenJnlLine."Source No." := PurchaseHeader."Pay-to Vendor No.";
            GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Posting No. Series" := GenJnlLine."Posting No. Series"; //                                                   
            GenJnlPostLine.RunWithCheck(GenJnlLine);

        END;
    END;

    // Compta timbre Vente
    procedure SalesPostTimbre(VAR SalesHeader: Record "Sales Header"; GenJnlPostLine: Codeunit 12; GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record 81;
        SourceCodeSetup: Record "Source Code Setup";
        Customerpostinggroup: Record "Customer Posting Group";
        SrcCode: code[10];
        CompteTimbre: Code[20];
        MntTimbre: Decimal;
    begin

        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.Sales;

        Customerpostinggroup.GET(SalesHeader."Customer Posting Group");
        IF SalesHeader."Apply Stamp Fiscal" THEN BEGIN
            Customerpostinggroup.TestField("Apply Stamp Fiscal"); //            
            Customerpostinggroup.TESTFIELD("Stamp Fiscal Account");
            Customerpostinggroup.TESTFIELD("Stamp Fiscal Amount"); //

            MntTimbre := 0;
            MntTimbre := Customerpostinggroup."Stamp Fiscal Amount";
            CompteTimbre := Customerpostinggroup."Stamp Fiscal Account";

            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := SalesHeader."Posting Date";
            GenJnlLine."Document Date" := SalesHeader."Document Date";
            GenJnlLine.Description := SalesHeader."Posting Description";
            GenJnlLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code"; //
            GenJnlLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code"; //
            GenJnlLine."Reason Code" := GenJnlLine."Reason Code"; //
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := CompteTimbre;
            GenJnlLine."Document Type" := GenJournalLine."Document Type";
            GenJnlLine."Document No." := GenJournalLine."Document No.";
            GenJnlLine."External Document No." := GenJournalLine."External Document No.";
            GenJnlLine."Currency Code" := GenJnlLine."Currency Code"; //FIXME:
            GenJnlLine.Amount := MntTimbre;
            GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
            GenJnlLine."Source Currency Amount" := MntTimbre;
            GenJnlLine."Amount (LCY)" := MntTimbre;
            IF SalesHeader."Currency Code" = '' THEN
                GenJnlLine."Currency Factor" := 1
            ELSE
                GenJnlLine."Currency Factor" := SalesHeader."Currency Factor";
            GenJnlLine.Correction := GenJnlLine.Correction; //FIXME:
            GenJnlLine."Sales/Purch. (LCY)" := 0;
            GenJnlLine."Profit (LCY)" := 0;
            GenJnlLine."Inv. Discount (LCY)" := 0;
            GenJnlLine."Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
            GenJnlLine."Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
            GenJnlLine."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."On Hold" := GenJnlLine."On Hold"; //
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"; //
            GenJnlLine."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No."; //
            GenJnlLine."Applies-to ID" := GenJnlLine."Applies-to ID"; //
            GenJnlLine."Allow Application" := GenJnlLine."Bal. Account No." = '';
            GenJnlLine."Due Date" := GenJnlLine."Due Date"; //
            GenJnlLine."Payment Terms Code" := GenJnlLine."Payment Terms Code"; //
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
            GenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
            GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Posting No. Series" := GenJnlLine."Posting No. Series"; //                                                   
            GenJnlPostLine.RunWithCheck(GenJnlLine);

        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure OnBeforePostCustomerEntryAddStamp(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        CustomerPostingGroup: Record "Customer Posting Group";
        MntTimbre: Decimal;
    begin
        CustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
        IF SalesHeader."Apply Stamp Fiscal" THEN BEGIN
            CustomerPostingGroup.TestField("Apply Stamp Fiscal"); //
            CustomerPostingGroup.TESTFIELD("Stamp Fiscal Account");
            CustomerPostingGroup.TESTFIELD("Stamp Fiscal Amount");

            MntTimbre := 0;
            MntTimbre := CustomerPostingGroup."Stamp Fiscal Amount";

            IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := GenJnlLine.Amount - MntTimbre;
                GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" - MntTimbre;
                GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" - MntTimbre;
            END
            ELSE BEGIN
                GenJnlLine.Amount := GenJnlLine.Amount + MntTimbre;
                GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" + MntTimbre;
                GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + MntTimbre;
            END;

        end;
    end;


    //Fin compta timbre vente


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    local procedure MyProcedure(var PurchaseHeader: Record "Purchase Header")
    var
        purchaseline: Record "Purchase Line";
    begin
        purchaseline.SetRange(purchaseline."Document Type", purchaseline."Document Type"::Order);
        purchaseline.SetRange(purchaseline."Document No.", PurchaseHeader."No.");
        if purchaseline.FindSet() then
            repeat
                purchaseline.TestField("Unit of Measure");
            until purchaseline.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostVendorEntry', '', false, false)]
    local procedure OnBeforePostVendorEntryAddStampAmount(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        VendorPostingGroup: Record "Vendor Posting Group";
        MntTimbre: Decimal;
    begin
        VendorPostingGroup.GET(PurchHeader."Vendor Posting Group");
        IF PurchHeader."Apply Stamp Fiscal" THEN BEGIN
            VendorPostingGroup.TestField("Apply Stamp Fiscal");
            VendorPostingGroup.TESTFIELD("Stamp Fiscal Account");
            VendorPostingGroup.TESTFIELD("Stamp Fiscal Amount");

            MntTimbre := 0;
            MntTimbre := VendorPostingGroup."Stamp Fiscal Amount";

            GenJnlLine.Amount := GenJnlLine.Amount - MntTimbre;
            GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" - MntTimbre;
            GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" - MntTimbre;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        purchasereqheader: Record "Purchase Request Header";
        docattachement: Record "Document Attachment";
    begin
        if DocumentAttachment."Table ID" = 50251 then begin
            RecRef.Open(DATABASE::"Purchase Request Header");
            if purchasereqheader.Get(DocumentAttachment."No.") then begin
                RecRef.GetTable(purchasereqheader);

            end;

        end;
        // case Rec."Table ID" of
        //     DATABASE::"Purchase Request Header":
        //         begin
        //             RecRef.Open(DATABASE::"Purchase Request Header");
        //             if purchasereqheader.Get(DocumentAttachment."No.") then
        //                 RecRef.GetTable(purchasereqheader);
        //         end;
        // end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        purchasereqheader: Record "Purchase Request Header";
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;

        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostVendorEntry', '', false, false)]
    local procedure OnBeforePostGLAndVendorPostTimbre(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
    begin
        PurchPostTimbre(PurchHeader, GenJnlPostLine, GenJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostCustomerEntry', '', false, false)]
    local procedure OnAfterPostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
    begin
        SalesPostTimbre(SalesHeader, GenJnlPostLine, GenJnlLine);
    end;

    // Fin Compta Timbre Achat

    /*
        // Compta Timbre vente
        procedure SalesPostTimbre(VAR SalesHeader: Record "Sales Header"; GenJnlPostLine: Codeunit 12; GenJOurnalLine: Record "Gen. Journal Line")
        var
            GenJnlLine: Record "Gen. Journal Line";
            SourceCodeSetup: Record "Source Code Setup";
            CustomerPostingGroup: Record "Customer Posting Group";
            SrcCode: code[10];
            CompteTimbre: Code[20];
            MntTimbre: Decimal;

        begin

            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup.Sales;

            CustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
            IF SalesHeader."Apply Stamp Fiscal" THEN BEGIN
                CustomerPostingGroup.TestField("Apply Stamp Fiscal");
                CustomerPostingGroup.TESTFIELD("Stamp Fiscal Account");
                CustomerPostingGroup.TESTFIELD("Stamp Fiscal Amount");

                MntTimbre := 0;
                MntTimbre := CustomerPostingGroup."Stamp Fiscal Amount";
                CompteTimbre := CustomerPostingGroup."Stamp Fiscal Account";

                GenJnlLine.INIT;
                GenJnlLine."Posting Date" := SalesHeader."Posting Date";
                GenJnlLine."Document Date" := SalesHeader."Document Date";
                GenJnlLine.Description := SalesHeader."Posting Description";
                GenJnlLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
                GenJnlLine."Reason Code" := SalesHeader."Reason Code";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine."Account No." := CompteTimbre;
                GenJnlLine."Document Type" := GenJOurnalLine."Document Type";
                GenJnlLine."Document No." := GenJOurnalLine."Document No.";
                GenJnlLine."External Document No." := SalesHeader."External Document No.";
                GenJnlLine."Currency Code" := SalesHeader."Currency Code";
                IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo" THEN BEGIN
                    GenJnlLine.Amount := MntTimbre;
                    GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
                    GenJnlLine."Source Currency Amount" := MntTimbre;
                    GenJnlLine."Amount (LCY)" := MntTimbre;
                END
                ELSE BEGIN
                    GenJnlLine.Amount := -MntTimbre;
                    GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
                    GenJnlLine."Source Currency Amount" := -MntTimbre;
                    GenJnlLine."Amount (LCY)" := -MntTimbre;
                END;
                IF GenJnlLine."Currency Code" = '' THEN
                    GenJnlLine."Currency Factor" := 1
                ELSE
                    GenJnlLine."Currency Factor" := GenJnlLine."Currency Factor";
                GenJnlLine.Correction := GenJnlLine.Correction;
                GenJnlLine."Sales/Purch. (LCY)" := 0;
                GenJnlLine."Profit (LCY)" := 0;
                GenJnlLine."Inv. Discount (LCY)" := 0;
                GenJnlLine."Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
                GenJnlLine."Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
                GenJnlLine."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."On Hold" := GenJnlLine."On Hold";
                GenJnlLine."Allow Application" := GenJnlLine."Bal. Account No." = '';
                GenJnlLine."Due Date" := SalesHeader."Due Date";
                GenJnlLine."Payment Terms Code" := SalesHeader."Payment Terms Code";
                GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
                GenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
                GenJnlLine."Source Code" := SrcCode;
                GenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            END;
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostCustomerEntry', '', false, false)]
        local procedure OnAfterPostCustomerEntryPostStamp(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
        var
        begin
            SalesPostTimbre(SalesHeader, GenJnlPostLine, GenJnlLine);
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
        local procedure OnBeforePostCustomerEntryAddStamp(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
        var
            CustomerPostingGroup: Record "Customer Posting Group";
            MntTimbre: Decimal;
        begin
            CustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
            IF SalesHeader."Apply Stamp Fiscal" THEN BEGIN
                CustomerPostingGroup.TestField("Apply Stamp Fiscal"); //
                CustomerPostingGroup.TESTFIELD("Stamp Fiscal Account");
                CustomerPostingGroup.TESTFIELD("Stamp Fiscal Amount");

                MntTimbre := 0;
                MntTimbre := CustomerPostingGroup."Stamp Fiscal Amount";

                IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo" THEN BEGIN
                    GenJnlLine.Amount := GenJnlLine.Amount - MntTimbre;
                    GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" - MntTimbre;
                    GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" - MntTimbre;
                END
                ELSE BEGIN
                    GenJnlLine.Amount := GenJnlLine.Amount + MntTimbre;
                    GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" + MntTimbre;
                    GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + MntTimbre;
                END;

            end;
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
        local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
        var
            CustomerPostingGroup: Record "Customer Posting Group";
            MntTimbre: Decimal;
        begin
            CustomerPostingGroup.GET(SalesHeader."Customer Posting Group"); //
            IF SalesHeader."Apply Stamp Fiscal" THEN BEGIN
                CustomerPostingGroup.TestField("Apply Stamp Fiscal");
                CustomerPostingGroup.TESTFIELD("Stamp Fiscal Account");
                CustomerPostingGroup.TESTFIELD("Stamp Fiscal Amount");

                MntTimbre := 0;
                MntTimbre := CustomerPostingGroup."Stamp Fiscal Amount";

                SalesInvHeader."Stamp fiscal Amount" := MntTimbre;
            end;
        end;

        // Fin Compta Timbre vente
        [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'No.', TRUE, TRUE)]
        procedure OnAfterValidateEventLineNo(VAR Rec: Record "Purchase Line"; VAR xRec: Record "Purchase Line"; CurrFieldNo: Integer)
        VAR
            PurchaseHeader: record 38;
        begin
            IF (xRec."No." <> Rec."No.") THEN BEGIN
                PurchaseHeader.RESET;
                PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
                Rec."Transit Folder Nos." := PurchaseHeader."Transit Folder Nos.";
            end;
        end;

        [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Transit Folder Nos.', TRUE, TRUE)]
        procedure OnAfterValidateEventLineTransitFolderNos(VAR Rec: Record "Purchase Header"; VAR xRec: Record "Purchase Header"; CurrFieldNo: Integer)
        VAR
            PurchaseLine: record 39;
        begin
            IF (xRec."Transit Folder Nos." <> Rec."Transit Folder Nos.") THEN BEGIN
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                PurchaseLine.SETRANGE("Document No.", Rec."No.");
                if PurchaseLine.FindSet then
                    repeat
                        PurchaseLine."Transit Folder Nos." := Rec."Transit Folder Nos.";
                        PurchaseLine.MODIFY;
                    until PurchaseLine.Next = 0;
            end;
        end;

        [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforeItemJnlPostLine', '', TRUE, TRUE)]
        procedure OnBeforeItemJnlPostLinePurchPost(var ItemJournalLine: Record "Item Journal Line"; PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; var IsHandled: Boolean; WhseReceiptHeader: Record "Warehouse Receipt Header"; WhseShipmentHeader: Record "Warehouse Shipment Header")
        VAR
        begin
            ItemJournalLine."Transit Folder Nos." := PurchaseLine."Transit Folder Nos.";
        end;

        [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', TRUE, TRUE)]
        procedure OnAfterInitItemLedgEntryItemJnlPostLine(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
        VAR
        begin
            NewItemLedgEntry."Transit Folder Nos." := ItemJournalLine."Transit Folder Nos.";
        end;

        [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitValueEntry', '', TRUE, TRUE)]
        procedure OnAfterInitValueEntryItemJnlPostLine(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer)
        VAR
        begin
            ValueEntry."Transit Folder Nos." := ItemJournalLine."Transit Folder Nos.";
        end;
*/
    procedure DA_ToOrder(Var RequestHeader: Record 50251)
    var
        PurchSetup: Record 312;
        PurchReqLine: Record 50252;
        PurchHeader: Record 38;
        Vendor: Record 23;
        CodeVendor: Code[20];
        Window: Dialog;
        Text001: TextConst ENU = 'Purchase order', FRA = 'Commande achat';
        Info: Text;
    begin
        info := 'Commande achat crées : ';
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Order Nos.");
        //RequestHeader.TestField("Vendor No.");
        //Vendor.Reset;
        //Vendor.Get(RequestHeader."Vendor No.");
        //Window.OPEN(Text001);
        PurchReqLine.RESET;
        PurchReqLine.SETCURRENTKEY("Request No.", "Vendor No.");
        PurchReqLine.SETRANGE("Request No.", RequestHeader."No.");
        PurchReqLine.SetRange("Purchase Order No.", '');
        PurchReqLine.SetRange("Purchase Order Line No.", 0);
        PurchReqLine.SetRange("Accept Action Message", true);
        PurchReqLine.SetRange("Action Type", PurchReqLine."Action Type"::Purchase);
        IF NOT PurchReqLine.IsEmpty then begin
            repeat
                IF PurchReqLine."Vendor No." <> CodeVendor THEN BEGIN
                    PurchHeader.INIT;
                    PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                    PurchHeader."No." := '';
                    PurchHeader."Posting Date" := TODAY;
                    PurchHeader.INSERT(TRUE);
                    PurchHeader."Order Date" := TODAY;
                    PurchHeader.VALIDATE("Buy-from Vendor No.", PurchReqLine."Vendor No.");
                    PurchHeader."Purchase Request No." := PurchReqLine."Request No.";
                    PurchHeader.VALIDATE("Shortcut Dimension 1 Code", RequestHeader."Shortcut Dimension 1 Code");
                    PurchHeader.VALIDATE("Shortcut Dimension 2 Code", RequestHeader."Shortcut Dimension 2 Code");
                    PurchHeader.MODIFY(TRUE);
                    InsertLineOrder(RequestHeader, PurchHeader);
                    //RequestHeader.Status := RequestHeader.Status::Ordered;
                    PurchHeader.MODIFY(TRUE);
                    CodeVendor := PurchReqLine."Vendor No.";
                    info += PurchHeader."No." + ',';
                end;
            until PurchReqLine.Next = 0;
            message(info);
        end else
            Error('Rien à commander!!');
    end;

    //modif_Zahr_05092022
    procedure DA_totransferorder(var requestheader: Record "Purchase Request Header")
    var
        transferheader: Record "Transfer Header";
        transferline: Record "Transfer Line";
        PurchReqLine: Record "Purchase Request Line";
        lineno: Integer;
        inventorysetup: Record "Inventory Setup";
        info: Text;
        location: Record Location;
    begin
        info := 'Ordre de transfert crées: ';
        inventorysetup.get();
        inventorysetup.TestField("Transfer Order Nos.");
        PurchReqLine.SETRANGE("Request No.", RequestHeader."No.");
        PurchReqLine.SetRange("Purchase Order No.", '');
        PurchReqLine.SetRange("Purchase Order Line No.", 0);
        PurchReqLine.SetRange("Accept Action Message", true);
        PurchReqLine.SetRange(Type, PurchReqLine.Type::Item);
        PurchReqLine.Setfilter(Inventory, '<>%1', 0);
        PurchReqLine.SetRange("Action Type", PurchReqLine."Action Type"::"Transfer Order");
        if PurchReqLine.FindSet() then;
        //Message('%1', PurchReqLine.Count);
        lineno := 10000;
        IF NOT PurchReqLine.IsEmpty then begin
            transferheader.Init();
            transferheader."No." := '';
            transferheader.INSERT(TRUE);
            if location.FindFirst() then;
            transferheader.validate("Shortcut Dimension 1 Code", requestheader."Shortcut Dimension 1 Code");
            transferheader.validate("Shortcut Dimension 2 Code", requestheader."Shortcut Dimension 2 Code");
            transferheader."Purchase Request No." := requestheader."No.";
            transferheader.validate("Transfer-from Code", PurchReqLine."Location Code");
            transferheader.Validate("Transfer-to Code", PurchReqLine."Transfer-to Code");
            transferheader.Validate("In-Transit Code", 'TRANSIT');
            transferheader.Modify(true);
            if PurchReqLine.FindSet() then
                repeat
                    transferline.Init();
                    transferline."Document No." := transferheader."No.";
                    transferline."Line No." += lineno;
                    transferline.Insert(true);
                    transferline.validate("Item No.", PurchReqLine."No.");
                    transferline.Description := PurchReqLine.Description;
                    transferline.validate(Quantity, PurchReqLine.Quantity);
                    transferline.Modify(true);
                    lineno += 10000;
                until PurchReqLine.Next() = 0;
            info += transferheader."No.";
            Message(info);
        end;
    end;

    procedure DA_ToBlanketOrder(Var RequestHeader: Record 50251)
    var
        PurchSetup: Record 312;
        PurchReqLine: Record 50252;
        PurchHeader: Record 38;
        Vendor: Record 23;
        CodeVendor: Code[20];
        Window: Dialog;
        Text001: TextConst ENU = 'Purchase order', FRA = 'Commande achat';
        Info: Text;
    begin
        info := 'Commande achat crées : ';
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Order Nos.");
        //RequestHeader.TestField("Vendor No.");
        //Vendor.Reset;
        //Vendor.Get(RequestHeader."Vendor No.");
        //Window.OPEN(Text001);
        PurchReqLine.RESET;
        PurchReqLine.SETCURRENTKEY("Request No.", "Vendor No.");
        PurchReqLine.SETRANGE("Request No.", RequestHeader."No.");
        PurchReqLine.SetRange("Purchase Order No.", '');
        PurchReqLine.SetRange("Purchase Order Line No.", 0);
        PurchReqLine.SetRange("Accept Action Message", true);
        PurchReqLine.SetRange("Action Type", PurchReqLine."Action Type"::"Blanket Order");
        IF NOT PurchReqLine.IsEmpty then begin
            repeat
                IF PurchReqLine."Vendor No." <> CodeVendor THEN BEGIN
                    PurchHeader.INIT;
                    PurchHeader."Document Type" := PurchHeader."Document Type"::"Blanket Order";
                    PurchHeader."No." := '';
                    PurchHeader."Posting Date" := TODAY;
                    PurchHeader.INSERT(TRUE);
                    PurchHeader."Order Date" := TODAY;
                    PurchHeader.VALIDATE("Buy-from Vendor No.", PurchReqLine."Vendor No.");
                    PurchHeader."Purchase Request No." := PurchReqLine."Request No.";
                    PurchHeader.VALIDATE("Shortcut Dimension 1 Code", RequestHeader."Shortcut Dimension 1 Code");
                    PurchHeader.VALIDATE("Shortcut Dimension 2 Code", RequestHeader."Shortcut Dimension 2 Code");
                    PurchHeader.MODIFY(TRUE);
                    InsertLineOrder(RequestHeader, PurchHeader);
                    //RequestHeader.Status := RequestHeader.Status::Ordered;
                    PurchHeader.MODIFY(TRUE);
                    CodeVendor := PurchReqLine."Vendor No.";
                    info += PurchHeader."No." + ',';
                end;
            until PurchReqLine.Next = 0;
            message(info);
        end else
            Error('Rien à commander!!');
    end;

    procedure InsertLineOrder(PurchRequestHeader: record 50251; var PurchOrderHeader: record 38)
    var
        PurchLine: Record 39;
        PurchReqLine: Record 50252;
        PurchSetup: Record 312;
    begin
        PurchSetup.GET;
        PurchReqLine.RESET;
        PurchReqLine.SetRange("Request No.", PurchRequestHeader."No.");
        if PurchOrderHeader."Document Type" = PurchOrderHeader."Document Type"::Order THEN begin
            PurchReqLine.SetRange("Vendor No.", PurchOrderHeader."Buy-from Vendor No.");
            PurchReqLine.SetRange("Purchase Order No.", '');
            PurchReqLine.SetRange("Purchase Order Line No.", 0);
            PurchReqLine.SetRange("Action Type", PurchReqLine."Action Type"::Purchase);
        end;
        if PurchOrderHeader."Document Type" = PurchOrderHeader."Document Type"::"Blanket Order" THEN begin
            PurchReqLine.SetRange("Vendor No.", PurchOrderHeader."Buy-from Vendor No.");
            PurchReqLine.SetRange("Purchase Order No.", '');
            PurchReqLine.SetRange("Purchase Order Line No.", 0);
            PurchReqLine.SetRange("Action Type", PurchReqLine."Action Type"::"Blanket Order");
        end;
        if PurchOrderHeader."Document Type" = PurchOrderHeader."Document Type"::Quote THEN begin
            PurchReqLine.SetRange("Purchase Order No.", '');
            PurchReqLine.SetRange("Purchase Order Line No.", 0);
            PurchReqLine.SetRange("Action Type", PurchReqLine."Action Type"::"Purchase Quote");
        end;
        PurchReqLine.SetRange("Accept Action Message", true);
        if PurchReqLine.FindSet then
            repeat

                PurchLine.INIT;
                PurchLine.VALIDATE("Document Type", PurchOrderHeader."Document Type");
                //PurchLine.VALIDATE("Buy-from Vendor No.", "Vendor No.");
                PurchLine.VALIDATE("Document No.", PurchOrderHeader."No.");
                PurchLine.VALIDATE("Line No.", PurchReqLine."Line No.");
                PurchLine.insert(true);
                PurchLine.VALIDATE(Type, PurchReqLine.Type);
                PurchLine.VALIDATE("No.", PurchReqLine."No.");
                PurchLine.VALIDATE("Location Code", PurchReqLine."Location Code");
                PurchLine.VALIDATE("Unit of Measure Code", PurchReqLine."Unit of Measure");
                PurchLine.VALIDATE(Quantity, PurchReqLine.Quantity);

                // if PurchReqLine.Inventory < PurchReqLine.Quantity then
                //     PurchLine.VALIDATE(Quantity, PurchReqLine.Quantity - PurchReqLine.Inventory);
                // if PurchReqLine.Inventory > PurchReqLine.Quantity then
                //     PurchLine.VALIDATE(Quantity, PurchReqLine.Quantity - PurchReqLine.Inventory);
                PurchLine.VALIDATE("Direct Unit Cost", PurchReqLine."Unit Cost (LCY)");
                PurchLine."Vendor Item No." := PurchReqLine."Vendor Item No.";
                PurchLine."Purchase Request No." := PurchReqLine."Request No.";
                PurchLine."Purchase Request Line No." := PurchReqLine."Line No.";
                PurchLine.Description := PurchReqLine.Description;
                PurchLine.VALIDATE("Location Code", PurchReqLine."Location Code");
                PurchLine.VALIDATE("Shortcut Dimension 1 Code", PurchReqLine."Shortcut Dimension 1 Code");
                PurchLine.VALIDATE("Shortcut Dimension 2 Code", PurchReqLine."Shortcut Dimension 2 Code");
                PurchLine.VALIDATE("Location Code", PurchReqLine."Location Code");
                purchline.modify(true);
                if (PurchOrderHeader."Document Type" = PurchOrderHeader."Document Type"::Order) then begin
                    PurchReqLine."Purchase Order No." := PurchLine."Document No.";
                    PurchReqLine."Purchase Order Line No." := PurchLine."Line No.";
                    PurchReqLine.MODIFY(TRUE);
                end;
            until PurchReqLine.Next = 0;
    end;

    procedure Worksheet_DA_ToOrder()
    var
        PurchSetup: Record 312;
        PurchReqLine: Record 50252;
        PurchHeader: Record 38;
        Vendor: Record 23;
        CodeVendor: Code[20];
        Window: Dialog;
        Text001: TextConst ENU = 'Purchase order', FRA = 'Commande achat';
        Info: Text;
    begin
        info := 'Commande achat crées : ';
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Order Nos.");
        //RequestHeader.TestField("Vendor No.");
        //Vendor.Reset;
        //Vendor.Get(RequestHeader."Vendor No.");
        //Window.OPEN(Text001);
        PurchReqLine.RESET;
        PurchReqLine.SETCURRENTKEY("Vendor No.", "Request No.");
        //PurchReqLine.SETRANGE("Request No.", RequestHeader."No.");
        PurchReqLine.SetFilter("Purchase Order No.", '=%1', '');
        PurchReqLine.SetRange("Accept Action Message", true);
        IF NOT PurchReqLine.IsEmpty then begin
            repeat
                IF PurchReqLine."Vendor No." <> CodeVendor THEN BEGIN
                    PurchHeader.INIT;
                    PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                    PurchHeader."No." := '';
                    PurchHeader."Posting Date" := TODAY;
                    PurchHeader.INSERT(TRUE);
                    PurchHeader."Order Date" := TODAY;
                    PurchHeader.VALIDATE("Buy-from Vendor No.", PurchReqLine."Vendor No.");
                    PurchHeader."Purchase Request No." := PurchReqLine."Request No.";
                    //PurchHeader.VALIDATE("Shortcut Dimension 1 Code", RequestHeader."Shortcut Dimension 1 Code");
                    //PurchHeader.VALIDATE("Shortcut Dimension 2 Code", RequestHeader."Shortcut Dimension 2 Code");
                    PurchHeader.MODIFY(TRUE);
                    Worksheet_InsertLineOrder(PurchHeader);
                    //RequestHeader.Status := RequestHeader.Status::Ordered;
                    PurchHeader.MODIFY(TRUE);
                    CodeVendor := PurchReqLine."Vendor No.";
                    info += PurchHeader."No." + ',';
                end;
            until PurchReqLine.Next = 0;
            message(info);
        end else
            Error('Rien à commander!!');
    end;

    [EventSubscriber(ObjectType::Codeunit, 96, 'OnBeforeInsertPurchOrderLine', '', true, true)]
    local procedure OnBeforeInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; PurchQuoteLine: Record "Purchase Line"; PurchQuoteHeader: Record "Purchase Header")
    var
        PurchreqLine: Record 50252;
    begin
        PurchOrderLine."Purchase Request No." := PurchQuoteLine."Purchase Request No.";
        PurchOrderLine."Purchase Request Line No." := PurchQuoteLine."Purchase Request Line No.";
        PurchOrderLine.Validate("Budget Date", Today);
    end;

    [EventSubscriber(ObjectType::Codeunit, 96, 'OnAfterInsertPurchOrderLine', '', true, true)]
    local procedure OnAfterInsertPurchOrderLine(var PurchaseQuoteLine: Record "Purchase Line"; var PurchaseOrderLine: Record "Purchase Line")
    var
        PurchreqLine: Record 50252;
        PurchSetup: Record 312;
    begin
        PurchSetup.GET;
        PurchreqLine.RESET;
        if PurchreqLine.GET(PurchaseOrderLine."Purchase Request No.", PurchaseOrderLine."Purchase Request Line No.") then begin
            PurchreqLine."Purchase Order No." := PurchaseOrderLine."Document No.";
            PurchreqLine."Purchase Order Line No." := PurchaseOrderLine."Line No.";
            if PurchSetup."Update request Line From CA" THEN begin
                PurchreqLine.validate("Vendor No.", PurchaseOrderLine."Buy-from Vendor No.");
                PurchreqLine.validate(Quantity, PurchaseOrderLine.Quantity);
                PurchreqLine."Location Code" := PurchaseOrderLine."Location Code";
                PurchreqLine.validate("Unit Cost", PurchaseOrderLine."Unit Cost");
                PurchreqLine.Modify;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 96, 'OnAfterInsertAllPurchOrderLines', '', true, true)]
    local procedure OnAfterInsertAllPurchOrderLines(var PurchOrderLine: Record "Purchase Line"; PurchQuoteHeader: Record "Purchase Header")
    var
        PurchreqHeader: Record 50251;
    begin
        PurchreqHeader.RESET;
        if PurchreqHeader.GET(PurchQuoteHeader."Purchase Request No.") then begin
            PurchreqHeader.Status := PurchreqHeader.Status::Released;
            PurchreqHeader.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 415, 'OnAfterReleasePurchaseDoc', '', true, true)]
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    var
        PurchreqHeader: Record 50251;
    begin
        PurchreqHeader.RESET;
        if PurchreqHeader.GET(PurchaseHeader."Purchase Request No.") then begin
            PurchreqHeader.isArchived := true;
            PurchreqHeader.Modify;
        end;
    end;

    procedure Worksheet_InsertLineOrder(var PurchOrderHeader: record 38)
    var
        PurchLine: Record 39;
        purch2line: Record "Purchase Line";
        PurchReqLine: Record "Purchase Request Line";
        purchaserequestline: Record "Purchase Request Line";
        LineNo: Integer;
    begin
        LineNo := 0;
        PurchReqLine.RESET;
        //PurchReqLine.SetRange("Request No.", PurchRequestHeader."No.");
        PurchReqLine.SetRange("Vendor No.", PurchOrderHeader."Buy-from Vendor No.");

        //PurchReqLine.SetFilter("Purchase Order No.", '<>%1', '');
        PurchReqLine.SetFilter("Purchase Order No.", '=%1', '');
        PurchReqLine.SetRange("Accept Action Message", true);
        if PurchReqLine.FindSet then begin
            // Message('%1', purchaserequestline.Count);
            repeat
                purch2line.SetRange("Document Type", PurchOrderHeader."Document Type");
                purch2line.SetRange("Document No.", PurchOrderHeader."No.");
                if purch2line.FindLast() then
                    LineNo += LineNo + 10000;

                PurchLine.INIT;
                PurchLine.VALIDATE("Document Type", PurchOrderHeader."Document Type");
                //PurchLine.VALIDATE("Buy-from Vendor No.", "Vendor No.");
                PurchLine.VALIDATE("Document No.", PurchOrderHeader."No.");
                PurchLine.VALIDATE("Line No.", LineNo);
                PurchLine.VALIDATE(Type, PurchReqLine.Type);
                PurchLine.VALIDATE("No.", PurchReqLine."No.");
                PurchLine.VALIDATE("Location Code", PurchReqLine."Location Code");
                PurchLine.VALIDATE("Unit of Measure Code", PurchReqLine."Unit of Measure");
                PurchLine.VALIDATE(Quantity, PurchReqLine.Quantity);
                PurchLine.VALIDATE("Direct Unit Cost", PurchReqLine."Unit Cost (LCY)");
                PurchLine."Vendor Item No." := PurchReqLine."Vendor Item No.";
                PurchLine."Purchase Request No." := PurchReqLine."Request No.";
                PurchLine."Purchase Request Line No." := PurchReqLine."Line No.";
                PurchLine.Description := PurchReqLine.Description;
                PurchLine.VALIDATE("Shortcut Dimension 1 Code", PurchReqLine."Shortcut Dimension 1 Code");
                PurchLine.VALIDATE("Shortcut Dimension 2 Code", PurchReqLine."Shortcut Dimension 2 Code");
                if PurchLine.INSERT(TRUE) then begin
                    purchaserequestline.get(PurchReqLine."Request No.", PurchReqLine."Line No.");
                    purchaserequestline."Purchase Order No." := PurchLine."Document No.";
                    purchaserequestline."Purchase Order Line No." := PurchLine."Line No.";
                    purchaserequestline.MODIFY();
                end;
            until PurchReqLine.Next = 0;
        end;

    end;

    // [EventSubscriber(ObjectType::Table, database::Vendor, 'OnBeforeModifyEvent', '', false, false)]
    // local procedure OnBeforeModifyEventVendor(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    // begin
    //     if RunTrigger = false then
    //         Rec.TestField(Rec.Status, Rec.Status::Open);
    // end;

    // [EventSubscriber(ObjectType::Table, database::Item, 'OnBeforeModifyEvent', '', false, false)]
    // local procedure OnBeforeModifyEventItem(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    // begin
    //     if RunTrigger = false then
    //         Rec.TestField(Rec.Status, Rec.Status::Open);
    // end;


}
