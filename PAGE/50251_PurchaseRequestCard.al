page 50251 PurchaseRequestCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    PromotedActionCategories = ' , , ,Naviguer';
    SourceTable = "Purchase Request Header";
    CaptionML = ENU = 'Request Purchase', FRA = 'Demande achat';
    //PromotedActionCategories = 'New,Process,Report,Manage,New Document,Request Approval,Customer';
    layout
    {
        area(Content)
        {
            //Defines a FastTab that has the heading 'General'.
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;

                }
                field("Create By"; Rec."Create By")
                {
                    ApplicationArea = All;
                    Editable = FALSE;

                }
                field("Create date"; Rec."Create Date")
                {
                    ApplicationArea = All;
                    Editable = FALSE;

                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("ID Request User"; Rec."ID Request User")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ShowMandatory = true;
                }
                field("ID Request Name"; Rec."ID Request Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Approval User ID"; Rec."Approval User ID")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Pending Approvals"; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
            }
            group(Lines)
            {
                CaptionML = FRA = 'Lignes', ENU = 'Lines';
                part(PurchaseRequestLine; PurchaseRequestLine)
                {
                    // Filter on the sales orders that relate to the customer in the card page.
                    SubPageLink = "Request No." = FIELD("No.");
                    ApplicationArea = ALL;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "No." = FIELD("No."), "Table ID" = filter('50251');
            }
            part(Control23; "Pending Approval FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Table ID" = CONST(50030),
                              "Document No." = FIELD("No.");
                //Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1903326807; "Item Replenishment FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchaseRequestLine;
                SubPageLink = "No." = FIELD("No.");
                Visible = true;
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = Suite;
                Visible = false;
            }
            part(Control1901138007; "Vendor Details FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchaseRequestLine;
                SubPageLink = "No." = FIELD("Vendor No.");
                Visible = false;
            }
            part(Control1904651607; "Vendor Statistics FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchaseRequestLine;
                SubPageLink = "No." = FIELD("Vendor No.");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Suite;
                ShowFilter = false;
                Visible = false;
            }
            part(Control1903435607; "Vendor Hist. Buy-from FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchaseRequestLine;
                SubPageLink = "No." = FIELD("Vendor No.");
            }
            part(Control1906949207; "Vendor Hist. Pay-to FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchaseRequestLine;
                SubPageLink = "No." = FIELD("Vendor No.");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Process)
            {
                //Defines action that display under the 'Actions' menu.
                action(Release)
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = ReleaseDoc;
                    CaptionML = ENU = 'Release', FRA = 'Lancer';
                    trigger OnAction()
                    var
                        emailAccount: Record "Email Account";
                        emailmessage: Codeunit "Email Message";
                        bodymessage: Text;
                        addbodymessage: Text;
                        emailSend: Codeunit Email;
                        recipinets: List of [Text];
                        employee: record Employee;
                        user: record User;
                    begin
                        /* if employee.Get("ID Request User") then begin
                             Clear(bodymessage);
                             Clear(addbodymessage);
                             Clear(recipinets);
                             if employee."E-Mail" <> '' then begin
                                 recipinets.Add(employee."E-Mail");
                                 bodymessage := 'Bonjour, <br><br> votre demande n° %1 est lancé';
                                 bodymessage += '<br><br><hr>ceci est un e-mail généré par le système. merci de ne pas répondre à ce mail<hr>';
                                 addbodymessage := StrSubstNo(bodymessage, Rec."No.");
                                 emailmessage.Create(recipinets, 'Demande lancé', addbodymessage, true);
                                 emailSend.Send(emailmessage, Enum::"Email Scenario"::Default);
                             end
                             else begin
                                 user.setrange("User Name", rec."Create By");
                                 if user.FindFirst() then begin
                                     Clear(bodymessage);
                                     Clear(addbodymessage);
                                     Clear(recipinets);
                                     if user."Authentication Email" <> '' then begin
                                         recipinets.Add(user."Authentication Email");
                                         bodymessage := 'Bonjour, <br><br> votre demande n° %1 est lancé';
                                         bodymessage += '<br><br><hr>ceci est un e-mail généré par le système. merci de ne pas répondre à ce mail<hr>';
                                         addbodymessage := StrSubstNo(bodymessage, Rec."No.");
                                         emailmessage.Create(recipinets, 'Demande lancé', addbodymessage, true);
                                         emailSend.Send(emailmessage, Enum::"Email Scenario"::Default);
                                     end;
                                 end;
                             end;
                         end;*/
                        Rec.Validate(Status, Rec.Status::Released);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = ReOpen;
                    CaptionML = ENU = 'Reopen', FRA = 'Réouvrir';
                    trigger OnAction()
                    begin
                        Rec.Validate(Status, Rec.Status::Open);

                    end;
                }
                action("Demande d'approbation")
                {
                    ApplicationArea = All;
                    //RunObject = page "Sales Quote";
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = SendApprovalRequest;
                    CaptionML = ENU = 'Approuval Request', FRA = 'Envoyer demande d''approbation';
                    trigger OnAction();
                    begin
                        Rec.TestField(isArchived, FALSE);
                        Rec.TestField(Status, Rec.Status::Open);
                        if ApprovalsMgmtCUT.CheckPurchaseApprovalPossible(Rec) then
                            ApprovalsMgmtCUT.OnSendRequestForApprovel(Rec);
                        CurrPage.Close();

                    end;
                }
                action("Annuler demande d'approbation")
                {
                    ApplicationArea = All;
                    //RunObject = page "Sales Quote";
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = SendApprovalRequest;
                    CaptionML = ENU = 'Cancel approval request', FRA = 'Annuler demande d''approbation';
                    trigger OnAction();
                    begin
                        Rec.TestField(isArchived, FALSE);
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        ApprovalsMgmtCUT.OnCancelRequestForApprovel(Rec);
                    end;
                }
                action("Create Purchase Order")
                {
                    ApplicationArea = All;
                    //RunObject = page "Sales Quote";
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = NewOrder;
                    CaptionML = ENU = 'Create Purchase Order', FRA = 'Créer commande achat';
                    trigger OnAction();
                    begin
                        //Rec.TestField(isArchived, FALSE);
                        //Rec.TestField("Shortcut Dimension 1 Code");
                        Rec.TestField("ID Request User");
                        PurchaseDoc.RESET;
                        PurchaseDoc.SETRANGE("Purchase Request No.", Rec."No.");
                        PurchaseDoc.SetRange("Document Type", PurchaseDoc."Document Type"::Order);
                        if PurchaseDoc.IsEmpty then begin
                            Rec.TestField(Status, Rec.Status::Released);
                            Subscribers.DA_ToOrder(Rec);
                        end else
                            Error('Vous avez déja des documents achat (devis, commande) encours pour cette demande achat %1', Rec."No.");
                    end;

                }
                action("Create Purchase Blanket Order")
                {
                    ApplicationArea = All;
                    //RunObject = page "Sales Quote";
                    Promoted = true;

                    PromotedCategory = Process;
                    Image = MakeOrder;
                    CaptionML = ENU = 'Create Purchase Blanket Order', FRA = 'Créer contrat achat';
                    trigger OnAction();
                    begin
                        //Rec.TestField(isArchived, FALSE);
                        //Rec.TestField("Shortcut Dimension 1 Code");
                        Rec.TestField("ID Request User");
                        PurchaseDoc.RESET;
                        PurchaseDoc.SetRange("Document Type", PurchaseDoc."Document Type"::"Blanket Order");
                        PurchaseDoc.SETRANGE("Purchase Request No.", Rec."No.");
                        if PurchaseDoc.IsEmpty then begin
                            Rec.TestField(Status, Rec.Status::Released);
                            Subscribers.DA_ToBlanketOrder(Rec);
                        end else
                            Error('Vous avez déja des documents achat (devis, commande, commande cadre) encours pour cette demande achat %1', Rec."No.");
                    end;
                }
                action("Create Purchase Quote")
                {
                    ApplicationArea = All;
                    //RunObject = page "Sales Quote";
                    Promoted = true;

                    PromotedCategory = Process;
                    Image = NewOrder;
                    CaptionML = ENU = 'Create Purchase Quote', FRA = 'Créer demande de prix';
                    trigger OnAction();
                    begin
                        //Rec.TestField("Shortcut Dimension 1 Code");
                        Rec.TestField("ID Request User");
                        Rec.TestField(isArchived, FALSE);
                        PurchaseDoc.RESET;
                        PurchaseDoc.SetRange("Document Type", PurchaseDoc."Document Type"::Quote);
                        PurchaseDoc.SETRANGE("Purchase Request No.", Rec."No.");
                        //PurchaseDoc.setfilter("Document Type", '<>%1', PurchaseDoc."Document Type"::Quote);
                        if PurchaseDoc.IsEmpty then begin
                            Rec.TestField(Status, Rec.Status::Released);
                            if Rec.Status <> Rec.Status::Refused then begin
                                Consult.SetRequestNo(Rec, 0);
                                Consult.Run();
                            end;

                        end else
                            Error('Vous avez déja des documents achat (devis, commande) encours pour cette demande achat %1', Rec."No.");
                    end;
                }
                action("Create Transfer Order")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;

                    Image = NewOrder;
                    CaptionML = ENU = 'Create Transfer Order', FRA = 'Créer ordre de transfert';
                    trigger OnAction()
                    begin
                        //Rec.TestField("Shortcut Dimension 1 Code");
                        Rec.TestField("ID Request User");
                        //Rec.TestField(isArchived, FALSE);
                        // PurchaseDoc.RESET;
                        // PurchaseDoc.SETRANGE("Purchase Request No.", Rec."No.");
                        transferheader.Reset();
                        transferheader.SetRange("Purchase Request No.", Rec."No.");
                        if transferheader.IsEmpty then begin
                            Rec.TestField(Status, Rec.Status::Released);
                            Subscribers.DA_totransferorder(Rec)
                        end else
                            Error('Vous avez déja des documents de transfert encours pour cette demande achat %1', Rec."No.");
                    end;

                }
            }
        }
        area(Navigation)
        {
            group(Navigate)
            {
                action("Commande achat")
                {
                    ApplicationArea = All;
                    PromotedCategory = Category4;
                    Promoted = true;
                    Image = Navigate;
                    CaptionML = ENU = 'Purchase Order', FRA = 'Commande achat';
                    RunObject = page "Purchase Lines";
                    RunPageLink = "Purchase Request No." = field("No."), "Document Type" = const(Order);
                }
                action("Demande de prix")
                {
                    ApplicationArea = All;
                    PromotedCategory = Category4;
                    Promoted = true;
                    Image = Navigate;
                    CaptionML = ENU = 'Purchase Quote', FRA = 'Demande de prix';
                    RunObject = page "Purchase Quotes";
                    RunPageLink = "Purchase Request No." = field("No.");
                }
                action("Commande achat cadre")
                {
                    ApplicationArea = All;
                    PromotedCategory = Category4;
                    Promoted = true;
                    Image = Navigate;
                    CaptionML = ENU = 'Blanket Purchase Order', FRA = 'Commande achat cadre';
                    RunObject = page "Blanket Purchase Orders";
                    RunPageLink = "Purchase Request No." = field("No.");
                }
                action("Transfer Order")
                {
                    ApplicationArea = All;
                    PromotedCategory = Category4;
                    Promoted = true;
                    Image = Navigate;
                    CaptionML = ENU = 'Transfer Order', FRA = 'Ordre de transfert';
                    RunObject = page "Transfer Orders";
                    RunPageLink = "Purchase Request No." = field("No.");
                }
            }
        }
    }
    var
        Subscribers: Codeunit 50252;
        Consult: Report 50252;
        ApprovalsMgmtCUT: Codeunit 50256;
        PurchaseDoc: Record 38;
        transferheader: Record "Transfer Header";
}