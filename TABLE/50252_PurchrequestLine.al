table 50252 "Purchase Request Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Request No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request No.';

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';

        }
        field(3; Type; Enum "Purchase Request Line Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(4; "No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
            TableRelation =
            if (Type = CONST(" ")) "Standard Text"
            else
            if (Type = CONST("G/L Account")) "G/L Account"
            else
            if (Type = CONST("Fixed Asset")) "Fixed Asset"
            else
            if (Type = CONST("Charge (Item)")) "Item Charge"
            else
            if (Type = CONST(Item)) Item;
            ValidateTableRelation = FALSE;

            trigger OnValidate()
            var

                StdText: Record 7;
                Item: Record 27;
                GLAccount: record 15;
                FixedAsset: record 5600;
                ItemCharge: Record 5800;
                PurchReqHeader: Record 50251;
                InventorySetup: Record "Inventory Setup";
                to: Record "Transfer Header";
            begin
                IF Type = Type::" " then begin
                    StdText.GET("No.");
                    Description := StdText.Description;
                end;
                IF Type = Type::Item THEN BEGIN
                    Item.RESET;
                    IF Item.GET("No.") THEN BEGIN
                        Item.TESTFIELD(Blocked, FALSE);
                        Description := Item.Description;
                        "Description 2" := Item."Description 2";
                        "Unit of Measure" := Item."Base Unit of Measure";
                        //Inventory := Item.Inventory;
                        "Vendor Item No." := Item."Vendor Item No.";
                        //"Unit Cost (LCY)" := Item."Unit Cost";
                    END;
                    Item.Reset();
                    if Item.get("No.") then begin
                        InventorySetup.get();
                        item.SetFilter("Location Filter", InventorySetup."Location Code");
                        Item.CalcFields(Inventory);
                        Inventory := item.Inventory;
                        "Action Type" := item."Purchase Request Action Type";
                        //ItemLedgerEnry.SetRange("Location Code", InventorySetup."Location Code");
                        //ItemLedgerEnry.SetRange("Item No.", "No.");
                        //if FindSet() then begin
                        //   Inventory := 0;
                        //   repeat
                        //      Inventory := Inventory + ItemLedgerEnry.Quantity;
                        //  until ItemLedgerEnry.Next() = 0;
                        // end;
                    end;
                END;

                IF Type = Type::"Charge (Item)" THEN BEGIN
                    ItemCharge.RESET;
                    IF ItemCharge.GET("No.") THEN
                        Description := ItemCharge.Description;
                END;

                IF Type = Type::"G/L Account" THEN BEGIN
                    GLAccount.RESET;
                    IF GLAccount.GET("No.") THEN BEGIN
                        GLAccount.TestField(Blocked, false);
                        GLAccount.TestField("Direct Posting", TRUE);
                        Description := GLAccount.Name;
                    END;
                END;
                IF Type = Type::"Fixed Asset" THEN BEGIN
                    FixedAsset.RESET;
                    IF FixedAsset.GET("No.") THEN
                        Description := FixedAsset.Description;
                END;
                PurchReqHeader.RESET;
                PurchReqHeader.GET("Request No.");
                VALIDATE("Shortcut Dimension 1 Code", PurchReqHeader."Shortcut Dimension 1 Code");
                Validate("Shortcut Dimension 2 Code", PurchReqHeader."Shortcut Dimension 2 Code");
                Validate("Shortcut Dimension 3 Code", PurchReqHeader."Shortcut Dimension 3 Code");

            end;
        }
        field(5; "Location Code"; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Location Code', FRA = 'Magasin';
            TableRelation = Location;

        }
        field(36; "Transfer-to Code"; Code[10])
        {
            CaptionML = ENU = 'Transfer-to Code', FRA = 'Magasin destination';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(6; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';

        }
        field(7; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description 2';

        }
        field(8; "Unit of Measure"; Text[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit of Measure', FRA = 'Unité';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;


        }
        field(9; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Quantity', FRA = 'Quantité';

            trigger OnValidate()
            var
            begin
                CalcAmountLine(Rec);
                // if Quantity < Inventory then
                //     "Action Type" := "Action Type"::"Transfer Order"
                // else
                //     "Action Type" := "Action Type"::Purchase;
            end;

        }
        field(10; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit Cost', FRA = 'Coût unitaire';

            trigger OnValidate()
            var
            begin
                CalcAmountLine(Rec);
            end;
        }
        field(11; "Expected Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expected Receipt Date', FRA = 'Date réception prévue';

        }
        field(12; "Shortcut Dimension 1 Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code', FRA = 'Code raccourci axe 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,2,1';

        }
        field(13; "Shortcut Dimension 2 Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code', FRA = 'Code raccourci axe 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,2,2';

        }
        field(14; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', FRA = 'Estimation HT';
            Editable = FALSE;
            trigger OnValidate()
            var
            begin
                profit := "Sales Amount" - Amount;
            end;
        }
        field(15; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor No.', FRA = 'N° fournisseur';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vendor: Record 23;
            begin
                Vendor.RESET;
                if Vendor.GET("Vendor No.") then;
                "Vendor Name" := Vendor.name;
                "Vendor Name 2" := Vendor."Name 2";
                Validate("Currency Code", Vendor."Currency Code");
            end;
        }
        field(16; "Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor Name', FRA = 'Nom fournisseur';
        }
        field(17; "Vendor Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor Name 2', FRA = 'Nom fournisseur (2ème ligne)';
        }
        field(18; "Vendor Item No."; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor Item No.', FRA = 'Référence fournisseur';
        }
        field(19; "Purchase Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Purchase Order No.', FRA = 'N° commande achat';
        }

        field(20; "Purchase Order Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Purchase Order Line No.', FRA = 'N° ligne commande achat';
        }

        field(21; "Accept Action Message"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Accept Action Message', FRA = 'Accepter message d''action';
        }
        field(22; "Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', FRA = 'Code devise';
            TableRelation = Currency;
            trigger OnValidate()
            var
            begin
                UpdateCurrencyFactor(Rec);
            end;
        }
        field(23; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor', FRA = 'Facteur devise';
            DecimalPlaces = 0 : 15;
        }
        field(24; "Unit Cost (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit Cost (LCY)', FRA = 'Coût unitaire DS';

            trigger OnValidate()
            var
            begin
                //"Amount (LCY)" := Quantity * "Unit Cost (LCY)";
            end;
        }
        field(25; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount (LCY)', FRA = 'Estimation achat HT DS';
            Editable = FALSE;
        }
        field(26; "Shortcut Dimension 3 Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 3 Code', FRA = 'Code raccourci axe 3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            CaptionClass = '1,2,3';
        }
        field(68; Inventory; Decimal)
        {

            Editable = false;
            CaptionML = ENU = 'Inventory', FRA = 'Stock';

        }
        field(70; "Action Type"; Enum "Action Type")
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Action Type', FRA = 'Type Action';
        }
        field(71; "Job No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job."No.";
            Caption = 'Job N°';


        }
        field(72; "Service Contract No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Contract Header"."Contract No.";
            Caption = 'Contract N°';
        }
        // field(73; "Customer No"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Customer N°';
        //     TableRelation = Customer."No.";
        //     trigger OnValidate()
        //     var
        //         Customer: Record Customer;
        //     begin
        //         if Customer.get("Customer No") then begin
        //             "Customer Name" := Customer.Name;
        //         end;
        //     end;
        // }
        // field(74; "Customer Name"; Text[100])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Customer Name';
        // }

        field(76; "Sales Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Amount';
            trigger OnValidate()
            var
            begin
                profit := "Sales Amount" - Amount;
            end;
        }
        field(77; Profit; Decimal)
        {
            Caption = 'Profit';
        }
    }
    keys
    {
        key(Key1; "Request No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Request No.", "Vendor No.")
        {
            Clustered = false;
        }
        key(Key3; "Vendor No.", "Request No.")
        {
            Clustered = false;
        }
    }
    var
    //myInt: Integer;

    // Table object triggers
    trigger OnInsert()
    begin
        "Accept Action Message" := true;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure UpdateCurrencyFactor(Var Rec: Record 50252)
    var
        PurchReqHeader: record 50251;
        CurrencyDate: Date;
        UpdateCurrencyExchangeRates: Codeunit 1281;
        CurrExchRate: Record 330;
    begin
        PurchReqHeader.GET("Request No.");
        if "Currency Code" <> '' then begin
            if PurchReqHeader."Request Date" <> 0D then
                CurrencyDate := PurchReqHeader."Request Date"
            else
                CurrencyDate := WORKDATE;
            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") then begin
                "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
            end;
        end else
            "Currency Factor" := 0;

        CalcAmountLine(Rec);
    end;

    procedure CalcAmountLine(Var Rec: Record 50252)
    var
        myInt: Integer;
    begin
        IF "Currency Code" = '' then begin
            "Unit Cost (LCY)" := "Unit Cost";
            Amount := Quantity * "Unit Cost";
            "Amount (LCY)" := Quantity * "Unit Cost (LCY)";
        end else begin
            TestField("Currency Factor");
            "Unit Cost (LCY)" := Round("Unit Cost" / "Currency Factor", 3, '>');
            Amount := Quantity * "Unit Cost";
            "Amount (LCY)" := Quantity * "Unit Cost (LCY)";
        end;

    end;
}