page 50253 "PurchaseRequestList"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Purchase Request Header";
    UsageCategory = Lists;
    CardPageId = PurchaseRequestCard;
    CaptionML = ENU = 'Purchase Request List', FRA = 'Liste demande achat';
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