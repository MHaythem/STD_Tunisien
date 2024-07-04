codeunit 50256 "Approvals Mgmt. Ext"
{
    Permissions = TableData "Approval Entry" = rm;
    [IntegrationEvent(false, false)]
    procedure OnSendRequestForApprovel(var Request: Record "Purchase Request header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelRequestForApprovel(var Request: Record "Purchase Request header")
    begin
    end;

    procedure OnUpdateRefuseStatusDocument(var ApprovalEntry: Record "Approval Entry")
    var
        Request: Record "purchase Request Header";
        PurchORder: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        ApprovalEntry.Get(ApprovalEntry."Entry No.");
        ApprovalEntry.Validate(Status, ApprovalEntry.Status::Rejected);
        ApprovalEntry.Modify(true);

        case ApprovalEntry."Table ID" of
            DATABASE::"purchase Request Header":
                begin
                    Request.get(ApprovalEntry."Document No.");
                    Request.Status := Request.Status::Refused;
                    Request.isArchived := true;
                    Request.Modify;
                end;
            DATABASE::"Purchase Header":
                begin
                    // PurchORder.get(ApprovalEntry."Document Type"::Order, ApprovalEntry."Document No.");
                    // PurchORder.Status := PurchORder.Status::Refused;
                    // PurchORder.Modify;
                    // ArchiveManagement.ArchivePurchDocument(PurchORder);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckPurchaseApprovalPossible(var PurchaseRequestHeader: Record "Purchase Request Header")
    begin
    end;

    procedure CheckPurchaseApprovalPossible(var Request: Record "Purchase Request header"): boolean
    begin
        NoWorkflowEnnableErr := 'Aucun flux de travail pour ce type';
        if not IsRequestDocApprovalsWorkflowEnable(Request) then
            Error(NoWorkflowEnnableErr);
        OnAfterCheckPurchaseApprovalPossible(Request);
        exit(true);
    end;

    procedure IsRequestDocApprovalsWorkflowEnable(var Request: Record "Purchase Request header"): boolean
    begin
        If request.Status <> Request.Status::Open then
            EXIT(false);
        EXIT(workflowMangement.CanExecuteWorkflow(Request, WorkflowEventHandlingCust.RunWorkflowOnSendRequestForApprovalCode));
    end;


    [Eventsubscriber(objectType::codeunit, CodeUnit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        Request: Record "Purchase Request header";
        TableNo: Integer;
    begin
        TableNo := DATABASE::"Purchase Request header";

        if (ApprovalEntry."Table ID" = TableNo)
        then begin
            Request.get(ApprovalEntry."Record ID to Approve");
            Request."Approval Date" := System.Today();

            Request.Modify();
        end;
    end;

    [Eventsubscriber(objectType::codeunit, CodeUnit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovelEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        request: record "Purchase Request header";
        yser: record User;
        Respensable: Record "User Setup";
        workflowuserGroup: Record "Workflow User Group";
        member: Record "Workflow User Group Member";
        line: Record "Purchase Request Line";
    begin
        case recref.Number of
            DataBase::"Purchase Request header":
                begin
                    ApprovalEntryArgument.Init();
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Record ID to Approve" := RecRef.RecordId;
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Approval Code" := WorkflowStepInstance."Workflow Code";
                    ApprovalEntryArgument."Workflow Step Instance ID" := WorkflowStepInstance.ID;
                    RecRef.settable(request);
                    request.CalcFields(Amount);
                    ApprovalEntryArgument."Approver ID" := request."Approval User ID";
                    ApprovalEntryArgument."Document No." := request."No.";
                    ApprovalEntryArgument.Amount := request.Amount;
                    line.SetRange("Request No.", request."No.");
                    line.FindFirst();
                    ApprovalEntryArgument."Currency Code" := line."Currency Code";
                    ApprovalEntryArgument."Amount (LCY)" := CurrExchRate.ExchangeAmtFCYToLCY(
                    request."Create Date", ApprovalEntryArgument."Currency Code",
                    ApprovalEntryArgument.Amount, line."Currency Factor");
                    ApprovalEntryArgument."Salespers./Purch. Code" := Respensable."Salespers./Purch. Code";
                    ApprovalEntryArgument.RecordCaption();
                    ApprovalEntryArgument.RecordDetails();
                end;
        end;
    end;

    [Eventsubscriber(objectType::codeunit, CodeUnit::"Page Management", 'OnConditionalCardPageIDNotFound', '', true, true)]
    procedure OnConditionalCardPageIDTC(RecordRef: RecordRef; var CardPageID: Integer)
    begin
        case RecordRef.Number of
            DATABASE::"Purchase Request header":
                CardPageID := Page::PurchaseRequestCard;
        end;
    end;

    [Eventsubscriber(objectType::codeunit, CodeUnit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', true, true)]
    procedure OnGetDocumentTypeAndNumber(var RecRef: RecordRef; var DocumentType: Text; var DocumentNo: Text; var IsHandled: Boolean)
    var
        PurchaseRequestHeader: Record "Purchase request Header";
        FieldRef: FieldRef;
    begin
        case RecRef.Number of
            DATABASE::"Purchase request Header":
                begin
                    DocumentType := RecRef.Caption;
                    FieldRef := RecRef.Field(1);
                    DocumentNo := Format(FieldRef.Value);
                end;
        end;
        GetDocumentTypeAndNumber(RecRef, DocumentType, DocumentNo, IsHandled);
    end;

    procedure GetDocumentTypeAndNumber(var RecRef: RecordRef; var DocumentType: Text; var DocumentNo: Text; var IsHandled: Boolean): Boolean
    begin
        exit(true);
    end;

    [EventSubscriber(ObjectType::Table, 454, 'OnAfterGetRecordDetails', '', true, true)]
    procedure recorddetatils(RecRef: RecordRef; ChangeRecordDetails: Text; var Details: Text)
    var
        purchaseRequestHeader: record "Purchase Request header";
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request header":
                begin
                    RecRef.SetTable(purchaseRequestHeader);

                    Details := '';
                    //StrSubstNo(
                    //'%1 ; %2:', purchaseRequestHeader."Purchase requester ", purchaseRequestHeader.Activity);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnSetReportFieldPlaceholders', '', false, false)]
    procedure OnBeforeCreateMailAndDispatch(RecRef: RecordRef; var Field1Label: Text; var Field1Value: Text; var Field2Label: Text; var Field2Value: Text; var Field3Label: Text; var Field3Value: Text)
    var
        purchaseRequestHeader: record "Purchase Request header";
        FieldRef: FieldRef;
    begin
        if (FORMAT(RecRef.FIELD(120).Value()) = 'Refused')
        then begin
            //Field1Label := 'Statut Document :';
            //Field1Value := Format(FieldRef.Value);

            Field1Label := purchaseRequestHeader.FieldCaption(Status);
            FieldRef := RecRef.Field(purchaseRequestHeader.FieldNo(Status));
            Field1Value := 'Refusé'//Format(FieldRef.Value);

        end
    end;

    //
    [EventSubscriber(ObjectType::Table, 454, 'OnBeforeInsertEvent', '', true, true)]
    procedure OnBeforeInsert(var Rec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        Request: Record "Purchase Request header";
        app: Record "Approval Entry";
    begin
        case Rec."Table ID" of
            DATABASE::"purchase Request Header":
                begin
                    Request.get(Rec."Document No.");
                    Rec."Due Date" := Request."Create Date";
                end;
        end;
    end;

    // [EventSubscriber(ObjectType::Table, 454, 'OnBeforeModifyEvent', '', true, true)]
    // procedure OnBeforeModify(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    // var
    //     Request: Record "Purchase Request header";
    //     app: Record "Approval Entry";

    // begin
    //     case Rec."Table ID" of
    //         DATABASE::"purchase Request Header":
    //             begin
    //                 Request.get(Rec."Document No.");
    //                 Rec."Due Date" := Request."Create Date";
    //             end;

    //     end;
    // end;

    procedure SendEmailRequester(ApprovalEntry: Record "Approval Entry"; PurchaseRequest: record "Purchase Request Header")
    var
        Email1: text;

        Motif: Text[100];
        userSetup: record "User Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
        BodyNotif: Label 'Bonjour <strong> %1</strong>,<br><br>La demande d''achat dont l''intitulée %2 a  été approuvée par le directeur  <strong> %3</strong> <br><br> Cordialement.';
        userInfo, approbatorinfo : record user;
    begin

        // Email1 := PurchaseRequest."Requester Email";

        // Recipients.Add(Email1);
        // Subject := 'Approbation Demande Achat N°' + PurchaseRequest."No.";
        // //Body := BodySalesPostedMsg;
        // Body := 'votre DA a été approuvé';//StrSubstNo(BodyNotif, userInfo."Full Name", PurchaseRequest."Purchase Object", approbatorinfo."Full Name");
        // EmailMessage.Create(Recipients, Subject, Body, true);

        // Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        message('ok');
    end;


    var
        workflowMangement: Codeunit 1501;
        WorkflowEventHandlingCust: Codeunit 50255;
        NoWorkflowEnnableErr: Text[60];
        CurrExchRate: Record "Currency Exchange Rate";
        ArchiveManagement: Codeunit 5063;
        ApprovalEntry: record "Approval Entry";
}