// pageextension 50280 DocumentAttachementExt extends "Document Attachment Factbox"
// {
//     layout
//     {
//         modify(Documents)
//         {
//             trigger OnDrillDown()
//             var
//                 Customer: Record Customer;
//                 Vendor: Record Vendor;
//                 Item: Record Item;
//                 Employee: Record Employee;
//                 FixedAsset: Record "Fixed Asset";
//                 Resource: Record Resource;
//                 SalesHeader: Record "Sales Header";
//                 PurchaseHeader: Record "Purchase Header";
//                 Job: Record Job;
//                 SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//                 SalesInvoiceHeader: Record "Sales Invoice Header";
//                 PurchInvHeader: Record "Purch. Inv. Header";
//                 PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
//                 VATReportHeader: Record "VAT Report Header";
//                 DocumentAttachmentDetails: Page "Document Attachment Details";
//                 RecRef: RecordRef;
//             begin
//                 case "Table ID" of
//                     0:
//                         exit;
//                     DATABASE::Customer:
//                         begin
//                             RecRef.Open(DATABASE::Customer);
//                             if Customer.Get("No.") then
//                                 RecRef.GetTable(Customer);
//                         end;
//                     DATABASE::Vendor:
//                         begin
//                             RecRef.Open(DATABASE::Vendor);
//                             if Vendor.Get("No.") then
//                                 RecRef.GetTable(Vendor);
//                         end;
//                     DATABASE::Item:
//                         begin
//                             RecRef.Open(DATABASE::Item);
//                             if Item.Get("No.") then
//                                 RecRef.GetTable(Item);
//                         end;
//                     DATABASE::Employee:
//                         begin
//                             RecRef.Open(DATABASE::Employee);
//                             if Employee.Get("No.") then
//                                 RecRef.GetTable(Employee);
//                         end;
//                     DATABASE::"Fixed Asset":
//                         begin
//                             RecRef.Open(DATABASE::"Fixed Asset");
//                             if FixedAsset.Get("No.") then
//                                 RecRef.GetTable(FixedAsset);
//                         end;
//                     DATABASE::Resource:
//                         begin
//                             RecRef.Open(DATABASE::Resource);
//                             if Resource.Get("No.") then
//                                 RecRef.GetTable(Resource);
//                         end;
//                     DATABASE::Job:
//                         begin
//                             RecRef.Open(DATABASE::Job);
//                             if Job.Get("No.") then
//                                 RecRef.GetTable(Job);
//                         end;
//                     DATABASE::"Sales Header":
//                         begin
//                             RecRef.Open(DATABASE::"Sales Header");
//                             if SalesHeader.Get("Document Type", "No.") then
//                                 RecRef.GetTable(SalesHeader);
//                         end;
//                     DATABASE::"Sales Invoice Header":
//                         begin
//                             RecRef.Open(DATABASE::"Sales Invoice Header");
//                             if SalesInvoiceHeader.Get("No.") then
//                                 RecRef.GetTable(SalesInvoiceHeader);
//                         end;
//                     DATABASE::"Sales Cr.Memo Header":
//                         begin
//                             RecRef.Open(DATABASE::"Sales Cr.Memo Header");
//                             if SalesCrMemoHeader.Get("No.") then
//                                 RecRef.GetTable(SalesCrMemoHeader);
//                         end;
//                     DATABASE::"Purchase Header":
//                         begin
//                             RecRef.Open(DATABASE::"Purchase Header");
//                             if PurchaseHeader.Get("Document Type", "No.") then
//                                 RecRef.GetTable(PurchaseHeader);
//                         end;
//                     DATABASE::"Purch. Inv. Header":
//                         begin
//                             RecRef.Open(DATABASE::"Purch. Inv. Header");
//                             if PurchInvHeader.Get("No.") then
//                                 RecRef.GetTable(PurchInvHeader);
//                         end;
//                     DATABASE::"Purch. Cr. Memo Hdr.":
//                         begin
//                             RecRef.Open(DATABASE::"Purch. Cr. Memo Hdr.");
//                             if PurchCrMemoHdr.Get("No.") then
//                                 RecRef.GetTable(PurchCrMemoHdr);
//                         end;
//                     DATABASE::"VAT Report Header":
//                         begin
//                             RecRef.Open(DATABASE::"VAT Report Header");
//                             if VATReportHeader.Get("VAT Report Config. Code", "No.") then
//                                 RecRef.GetTable(VATReportHeader);
//                         end;
//                     else

//                 end;

//                 DocumentAttachmentDetails.OpenForRecRef(RecRef);
//                 DocumentAttachmentDetails.RunModal();
//             end;
//         }
//     }

//     actions
//     {
//         // Add changes to page actions here
//     }

//     var
//         myInt: Integer;
// }