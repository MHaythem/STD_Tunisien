codeunit 50255 "Workflow Event Handling Ext"
{
    Permissions = TableData "Approval Entry" = rm;

    var
        myInt: Integer;
        ArchiveManagement: Codeunit 5063;
        WorklflowManagement: Codeunit 1501;
        WorkflowEventHandlin: Codeunit 1520;
        PurchaseSendForApprovalEventDescTxt: Label 'Approval of a purchase request document';
        PurchaseRequestApprovalRequestCancelEventDescTxt: Label 'Approval of a Purchase Request document is canceled';
        PurchaseRequestApprovalRequestRejectEventDescTxt: Label 'Approval of a Purchase Request document is rejected';

    procedure RunWorkflowOnSendRequestForApprovalCode(): code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPurchaseRequestForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Approvals Mgmt. Ext", 'OnSendRequestForApprovel', '', true, true)]
    local procedure RunWorkflowOnSendPurchaseRequestForApproval(var Request: Record "Purchase Request header")
    begin
        WorklflowManagement.HandleEvent(RunWorkflowOnSendRequestForApprovalCode, Request);
    end;

    procedure RunWorkflowOnCancelRequestForApprovalCode(): code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelPurchaseRequestForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Approvals Mgmt. Ext", 'OnCancelRequestForApprovel', '', true, true)]
    local procedure RunWorkflowOnCancelPurchaseRequestForApproval(var Request: Record "Purchase Request header")
    begin
        WorklflowManagement.HandleEvent(RunWorkflowOnCancelRequestForApprovalCode(), Request);

    end;

    procedure RunWorkflowOnRejectRequestForApprovalCode(): code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectPurchaseRequestForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        WorklflowManagement.HandleEvent(RunWorkflowOnRejectRequestForApprovalCode(), ApprovalEntry);

    end;

    procedure SetStatusToPendingPrepaymentRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
        Request: Record "Purchase Request header";
        Purchorder: Record "Purchase Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Purchase Request header":
                begin
                    RecRef.SetTable(Request);
                    Request.Validate("Status", Request."Status"::Refused);
                    Request.Modify();
                    Variant := Request;
                end;
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(Purchorder);
                    Purchorder.Validate("Status", Purchorder."Status"::"Pending Prepayment");
                    Purchorder.Modify();
                    Variant := Purchorder;
                end;
        end;
    end;

    procedure SetStatusToPendingApprovalCodePurchaseRequest(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApprovalRequest'));
    end;

    procedure SetStatusToPendingApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
        Request: Record "Purchase Request header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::Job:
                begin
                    RecRef.SetTable(Request);
                    Request.Validate("Status", Request."Status"::"Pending Approval");
                    Request.Modify();
                    Variant := Request;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandlin.AddEventToLibrary(RunWorkflowOnSendRequestForApprovalCode, Database::"Purchase Request header", PurchaseSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandlin.AddEventToLibrary(RunWorkflowOnCancelRequestForApprovalCode, Database::"Purchase Request header", PurchaseRequestApprovalRequestCancelEventDescTxt, 0, false);
        WorkflowEventHandlin.AddEventToLibrary(RunWorkflowOnRejectRequestForApprovalCode, Database::"Purchase Request header", PurchaseRequestApprovalRequestRejectEventDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelRequestForApprovalCode:
                WorkflowEventHandlin.AddEventPredecessor(RunWorkflowOnCancelRequestForApprovalCode, RunWorkflowOnSendRequestForApprovalCode);
            // WorkflowEventHandlin.RunWorkflowOnApproveApprovalRequestCode:
            //     WorkflowEventHandlin.AddEventPredecessor(WorkflowEventHandlin.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendRequestForApprovalCode);
            RunWorkflowOnRejectRequestForApprovalCode:
                WorkflowEventHandlin.AddEventPredecessor(RunWorkflowOnRejectRequestForApprovalCode, RunWorkflowOnSendRequestForApprovalCode);
        end;
    end;
}