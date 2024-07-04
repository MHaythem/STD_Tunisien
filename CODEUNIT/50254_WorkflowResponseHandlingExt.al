codeunit 50254 "Workflow Response Handling Ext"
{
    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; Var Handled: Boolean)
    var
        Request: Record "purchase Request Header";
        PurchORder: Record "Purchase Header";
        Vendor: Record Vendor;
        Item: Record Item;
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request header":
                begin
                    RecRef.SetTable(Request);
                    Request.Status := Request.Status::Open;
                    Request.Modify;
                    Handled := true;
                end;

            DATABASE::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    Vendor.Status := Vendor.Status::Open;
                    Vendor.Modify();
                    Handled := true;
                end;

            DATABASE::Item:
                begin
                    RecRef.SetTable(Item);
                    Item.Status := Item.Status::Open;
                    Item.Modify();
                    Handled := true;
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; Var Handled: Boolean)
    var
        Request: Record "purchase Request Header";
        PurchORder: Record "Purchase Header";
        Vendor: Record Vendor;
        Item: Record Item;
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request header":
                begin
                    RecRef.SetTable(Request);
                    Request.Status := Request.Status::Released;
                    Request.Modify;
                    Handled := true;
                end;
            Database::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    Vendor.Status := Vendor.Status::Released;
                    Vendor.Modify();
                    Handled := true;
                end;
            DATABASE::Item:
                begin
                    RecRef.SetTable(Item);
                    Item.Status := Item.Status::Released;
                    Item.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; Var Variant: Variant; var Ishandled: Boolean)
    var
        Request: Record "purchase Request Header";
        PurchORder: Record "Purchase Header";
        Vendor: Record Vendor;
        Item: Record Item;
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request header":
                begin
                    RecRef.SetTable(Request);
                    Request.Status := Request.Status::"Pending Approval";
                    Request.Modify;
                    isHandled := true;
                end;
            Database::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    Vendor.Status := Vendor.Status::"Pending Approval";
                    Vendor.Modify();
                    IsHandled := true;
                end;
            DATABASE::Item:
                begin
                    RecRef.SetTable(Item);
                    Item.Status := Item.Status::"Pending Approval";
                    Item.Modify();
                    ISHandled := true;
                end;
        // DATABASE::"Purchase Header":
        //     begin

        //         RecRef.SetTable(PurchORder);
        //         PurchORder.Status := PurchORder.Status::"Pending Prepayment";
        //         //PurchORder.isArchived := true;
        //         PurchORder.Modify;
        //         isHandled := true;
        //     end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit 1521;
        WorkflowEventHandlingCust: Codeunit 50255;
        WorkflowResponseHandlingEXT: Codeunit "Workflow Response Handling Ext";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode,
                                    WorkflowEventHandlingCust.RunWorkflowOnSendRequestForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode,
                    WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode,
                    WorkflowEventHandling.RunWorkflowOnSendITEMForApprovalCode());
                end;

            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
                                    WorkflowEventHandlingCust.RunWorkflowOnSendRequestForApprovalCode);

                end;

            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode,
                                    WorkflowEventHandlingCust.RunWorkflowOnCancelRequestForApprovalCode);
                end;

            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode,
                                    WorkflowEventHandlingCust.RunWorkflowOnCancelRequestForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode,
                    WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode());
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode,
                    WorkflowEventHandling.RunWorkflowOnCancelItemApprovalRequestCode());
                end;


            NotifRequesterResponseCode():
                WorkflowResponseHandling.AddResponsePredecessor(NotifRequesterResponseCode(), WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure AddMyWorkflowResponsesToLibrary()
    var
        WorkflowEventHandling: codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin

        WorkflowResponseHandling.AddResponseToLibrary(NotifRequesterResponseCode, Database::"Approval Entry", 'Notif Requester', 'GROUP 0');
    End;
    //ADD Execute Respense
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    procedure ExecuteMyWorkflowResponses(ResponseWorkflowStepInstance: Record "Workflow Step Instance"; var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant)
    var
        WorkflowResponse: record "Workflow Response";
        ApprovalEntry: record "Approval Entry";
    begin
        if WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                NotifRequesterResponseCode:
                    BEGIN
                        NotifRequesterResponse(Variant);
                        ResponseExecuted := TRUE;
                    END;

            END;
    end;

    procedure NotifRequesterResponseCode(): Code[128]
    begin
        exit(UpperCase('NotifRequesterResponseCode'));
    end;

    procedure NotifRequesterResponse(appro: Record "Approval Entry")
    var
        //purchaseRequest: Record "Purchase Request Header";
        ApprovalMGTExt: Codeunit "Approvals Mgmt. Ext";
    begin
        // case ApprovalEntry."Table ID" of
        //     DATABASE::"Purchase Request Header":
        //         begin
        //             if purchaseRequest.get(ApprovalEntry."Record ID to Approve") then
        //                 ApprovalMGTExt.SendEmailRequester(ApprovalEntry, purchaseRequest);
        //         end;
        // end;
    end;
}
