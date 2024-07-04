enum 50252 "Purchase Request Line Type"
{
    //ENU=" ,G/L Account,Item,,Fixed Asset,Charge (Item)";
    //FRA=" ,Compte gnéral,Article,,Immobilisation,Frais annexes"
    Extensible = true;
    // Open,Released,Pending Approval,Pending Prepayment;FRA=Ouvert,Lancé,Approbation suspendue,Acompte suspendu
    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }
    value(1; "G/L Account")
    {
        CaptionML = ENU = 'G/L Account', FRA = 'Compte général';
    }
    value(2; "Item")
    {
        CaptionML = ENU = 'Item', FRA = 'Article';
    }
    value(3; "")
    {
        CaptionML = ENU = '', FRA = '';
    }
    value(4; "Fixed Asset")
    {
        CaptionML = ENU = 'Fixed Asset', FRA = 'Immobilisation';
    }
    value(5; "Charge (Item)")
    {
        CaptionML = ENU = 'Charge (Item)', FRA = 'Frais annexes';
    }
}