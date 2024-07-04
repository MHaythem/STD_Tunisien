report 50254 "Receipt List Not Invoiced"
{
    CaptionML = ENU = 'Receipt List Not Invoiced', FRA = 'Liste réception non facturée';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'REPOR\Receipt List Not Invoiced.rdl';
    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {
            }
            column(Document_Date; "Document Date")
            {
            }

            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                // DataItemTableView = where("Quantity Invoiced" = filter(<> 0));
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
                // column(Amount; Amount)
                // {
                // }
                // column(Amount_Including_VAT; "Amount Including VAT")
                // {
                // }
                column(Quantity; Quantity)
                {
                }
                // column(Quantity_Received; "Quantity Received")
                // {
                // }
                // column(Qty__to_Receive; "Qty. to Receive")
                // {
                // }
                column(Description; Description)
                {
                }
                column(Quantity_Invoiced; "Quantity Invoiced")
                {
                }
                // column(Qty__to_Invoice; "Qty. to Invoice")
                // {
                // }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Vendors.get("Purch. Rcpt. Line"."Pay-to Vendor No.");

                    if ("Purch. Rcpt. Line"."Quantity Invoiced" = "Purch. Rcpt. Line".Quantity) then begin
                        CurrReport.Skip();
                    end;
                end;
            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

            end;
        }
    }

    var
        Vendors: Record Vendor;
}