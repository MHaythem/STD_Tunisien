page 50255 "PurRequestListPendingApproval"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Purchase Request Header";
    SourceTableView = sorting("No.") order(ascending)
    where(Status = filter("Pending Approval"));
    UsageCategory = Lists;
    CardPageId = PurchaseRequestCard;
    Caption = 'Liste demande achat approbation suspendue';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;

                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = All;
                }
                field("Create By"; Rec."Create By")
                {
                    ApplicationArea = All;

                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;

                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;

                }

                field("Shortcut Dimension 1 Code"; Rec."Create By")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 2 Code"; Rec."Create By")
                {
                    ApplicationArea = All;

                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;

                }

            }
        }

    }
}