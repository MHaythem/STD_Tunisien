report 50251 PurchaseRequest
{
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseRequest.rdlc';
    CaptionML = ENG = 'Purchase Request', FRA = 'Demande achat';
    ObsoleteState = Pending;
    ObsoleteReason = 'Infrequently used report.';
    ObsoleteTag = '18.0';

    dataset
    {
        dataitem("Purchase Request Header"; "Purchase Request Header")
        {
            column(PurchReqNo; "No.")
            {
            }
        }
        dataitem(PurchReqLine; "Purchase Request Line")
        {
            column(Type; purchreqLine.Type)
            {
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; '')
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
}