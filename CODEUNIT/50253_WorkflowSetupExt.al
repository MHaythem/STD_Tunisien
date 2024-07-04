codeunit 50253 "Workflow Setup Ext"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(RequestWorkflowCategoryTxt, RequestApprovalWorkfowDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record 454;
    begin
        WorkflowSetup.InsertTableRelation(DATABASE::"Purchase Request header", 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInitWorkflowTemplates', '', false, false)]
    procedure OnInsertWorkflowTemplates()
    var
        workflow: record Workflow;

    begin
        workflow.Reset();
        workflow.SetRange(Category, RequestWorkflowCategoryTxt);
        if (workflow.FindSet()) then begin
            if (workflow.Template = false) then
                InsertRequestApprovalWorkflowTemplates();
            exit;
        end
        else
            InsertRequestApprovalWorkflowTemplates();

    end;

    [EventSubscriber(ObjectType::Codeunit, codeUnit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplate()
    begin
        InsertRequestApprovalWorkflowTemplates();
    end;

    local procedure InsertRequestApprovalWorkflowTemplates()
    var
        Workflow: Record 1501;
    begin
        WorkflowSetup.InsertWorkflowTemplate(workflow, RequestApprovalWorkflowCodeTxt, RequestApprovalWorkfowDescTxt, RequestWorkflowCategoryTxt);
        InsertRequestApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertRequestApprovalWorkflowDetails(var Workflow: Record 1501)
    var
        WorkflowStepArgument: Record 1523;
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit 50255;
        WorklowResponseHandling: codeunit 1521;
        Request: record "Purchase Request header";
    begin
        // WorkflowSetup.PopulateWorkflowStepArgument(WorkflowStepArgument,
        // WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver"
        // , 0, '', BlankDateFormula, TRUE);
        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildRequestTypeConditions(Request.Status::Open),
            WorkflowEventHandlingCust.RunWorkflowOnSendRequestForApprovalCode,
            BuildRequestTypeConditions(Request.Status::"Pending Approval"),
            WorkflowEventHandlingCust.RunWorkflowOnCancelRequestForApprovalCode,
            WorkflowStepArgument,
            True);
    end;

    local procedure BuildRequestTypeConditions(Status: Integer): Text
    var
        Request: record "Purchase Request Header";
    begin
        request.SetRange("status", Status);
        EXIT(StrSubstNo(RequestTypeCondTxt, WorkflowSetup.Encode(Request.GetView(FALSE))));

    end;

    var
        myInt: Integer;
        WorkflowSetup: Codeunit 1502;
        RequestWorkflowCategoryTxt: Label 'RDW';

        RequestWorkflowCategoryDescTxt: Label 'Request Document';

        RequestApprovalWorkflowCodeTxt: Label 'RAPW';

        RequestApprovalWorkfowDescTxt: Label 'Request Approval Workflow';

        RequestTypeCondTxt: Label '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name=”PurchaseRequest”>%1</DataItem></DataItems></ReportParameters> ';
}