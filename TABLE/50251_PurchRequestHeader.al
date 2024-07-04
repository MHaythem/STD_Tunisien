table 50251 "Purchase Request Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', FRA = 'N°';

        }
        field(2; Status; Enum "Purchase Request Status")
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', FRA = 'Statut';
            Editable = false;
        }
        field(3; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'request Date', FRA = 'Date demande';
        }

        field(4; "Create Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Create Date', FRA = 'Date création';
        }
        field(5; "Create By"; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Create By', FRA = 'Créer par';
            TableRelation = User;
        }
        field(6; "Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Modified Date', FRA = 'Date modification';
        }
        field(7; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Modified By', FRA = 'Modifier par';
            TableRelation = User;
        }
        field(8; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Series', FRA = 'Souches de n°';
            TableRelation = "No. Series";
        }
        field(9; "ID Request User"; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'ID Request User', FRA = 'ID demandeur';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: record Employee;
            begin
                if "ID Request User" <> '' then begin
                    Employee.SetRange("No.", "ID Request User");
                    if Employee.FindSet() then begin
                        "ID Request Name" := Employee.FullName();
                        "Requester Email" := Employee."E-Mail";
                    end;
                end
                else begin
                    "ID Request Name" := '';
                    "Requester Email" := '';
                end;
            end;
        }
        field(10; "ID Request Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'ID Request Name', FRA = 'Nom demandeur';

        }

        field(11; "Approval User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval User ID', FRA = 'ID approbateur';
            TableRelation = "User Setup";
        }

        field(12; "Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Date', FRA = 'Date approbation';

        }
        field(13; "Pending Approvals"; Integer)
        {
            //DataClassification = ToBeClassified;
            CaptionML = ENU = 'Pending Approvals', FRA = 'Approbation en attente';
            //TableRelation = "Dimension Set Entry";
            Editable = FALSE;
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(50251), "Document No." = FIELD("No."), Status = FILTER(Open | Created)));
        }

        field(17; "Shortcut Dimension 1 Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code', FRA = 'Code raccourci axe 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,2,1';

            trigger OnValidate()
            var
                purchrequestline: record "Purchase Request Line";
            begin
                if Confirm('Vous avez Probablement modifié un axe analytique,Souhaitez-vous mettre à jour les lignes?', true) then begin
                    purchrequestline.SetRange("Request No.", "No.");
                    if purchrequestline.FindSet() then
                        repeat
                            purchrequestline."Shortcut Dimension 1 Code" := rec."Shortcut Dimension 1 Code";
                            purchrequestline.Modify();
                        until purchrequestline.Next() = 0;
                end;
            end;
        }
        field(18; "Shortcut Dimension 2 Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code', FRA = 'Code raccourci axe 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,2,2';

            trigger OnValidate()
            var
                purchrequestline: record "Purchase Request Line";
            begin
                if Confirm('Vous avez Probablement modifié un axe analytique,Souhaitez-vous mettre à jour les lignes?', true) then begin
                    purchrequestline.SetRange("Request No.", "No.");
                    if purchrequestline.FindSet() then
                        repeat
                            purchrequestline."Shortcut Dimension 2 Code" := rec."Shortcut Dimension 2 Code";
                            purchrequestline.Modify();
                        until purchrequestline.Next() = 0;
                end;
            end;
        }
        field(19; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID', FRA = 'ID ensemble de dimensions';
            TableRelation = "Dimension Set Entry";
            Editable = FALSE;
        }


        field(20; "isArchived"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'isArchived', FRA = 'Archivé';
            Editable = FALSE;
        }
        field(21; Amount; Decimal)
        {
            //DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', FRA = 'Montant';
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Request Line".Amount WHERE("Request No." = FIELD("No.")));
        }
        field(22; "Requester Email"; Text[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'Requester Email';
        }
        field(23; "Shortcut Dimension 3 Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 3 Code', FRA = 'Code raccourci axe 3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            CaptionClass = '1,2,3';

            trigger OnValidate()
            var
                purchrequestline: record "Purchase Request Line";
            begin
                if Confirm('Vous avez Probablement modifié un axe analytique,Souhaitez-vous mettre à jour les lignes?', true) then begin
                    purchrequestline.SetRange("Request No.", "No.");
                    if purchrequestline.FindSet() then
                        repeat
                            purchrequestline."Shortcut Dimension 3 Code" := rec."Shortcut Dimension 3 Code";
                            purchrequestline.Modify();
                        until purchrequestline.Next() = 0;
                end;
            end;
        }
        field(24; "Job No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job."No.";
            Caption = 'Job N°';
            // trigger OnValidate()
            // var
            //     JobRec: Record Job;
            // begin
            //     if JobRec.get("Job No") then
            //         "Description Job/Contract" := JobRec.Description;
            // end;
        }
        field(25; "Contract No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Contract Header"."Contract No.";
            Caption = 'Contract N°';
            // trigger OnValidate()
            // var
            //     Contract: Record "Service Contract Header";
            // begin
            //     if Contract.get("Contract No") then
            //         "Description Job/Contract" := Contract.Description;
            // end;
        }
        field(26; "Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer N°';
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.get("Customer No") then begin
                    "Customer Name" := Customer.Name;
                end;
            end;
        }
        field(27; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer Name';
        }
        field(28; "Description Job/Contract"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description Job/Contract';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        PurchSetup: Record 312;
        test: record 38;

        NoSeriesManagement: Codeunit 396;


    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD("Purchase request No.");
            NoSeriesManagement.InitSeries(PurchSetup."Purchase request No.", xRec."No. Series", WORKDATE, "No.", "No. Series");
        END;
        "Request Date" := WORKDATE;
        "Create By" := USERID;
        "Create Date" := Today;
        "ID Request User" := UserId;
    end;

    trigger OnModify()
    begin
        "Modified By" := UserId;
        "Modified Date" := Today;
    end;

    trigger OnDelete()
    begin
        //TestField(Status, Status::Open);
    end;

    trigger OnRename()
    begin
        Error(' ');
    end;

    var
        DimMgt: Codeunit DimensionManagement;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        //OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            //if PurchLinesExist then
            //UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

        //OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;
}