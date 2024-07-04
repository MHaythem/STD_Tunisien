report 50253 "Purch Order List Not Received"
{
    CaptionML = ENU = 'Purchase Order List Not Received', FRA = 'Liste commandes achats non récéptionnées';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'REPOR\Purchase Order List Not Received.rdl';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";
            column(No_; "No.")
            {
            }
            column(Document_Date; "Document Date")
            {
            }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Document_No_; "Document No.")
                {
                }
                column(No_Article; "No.")
                {
                }
                column(Pay_to_Vendor_No_; "Pay-to Vendor No.")
                {
                }

                column(Vendor_Name; Vendors.Name)
                {
                }
                column(Amount; Amount)
                {
                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Quantity_Received; "Quantity Received")
                {
                }
                column(Qty__to_Receive; "Qty. to Receive")
                {
                }
                column(Description; Description)
                {
                }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    if Vendors.get("Purchase Line"."Pay-to Vendor No.") then;
                    if "Purchase Line".Quantity = "Purchase Line"."Quantity Received" then
                        CurrReport.Skip();
                end;
            }

        }
    }

    var
        Vendors: Record Vendor;
}