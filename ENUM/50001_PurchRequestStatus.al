enum 50251 "Purchase Request Status"
{
    Extensible = true;
    // Open,Released,Pending Approval,Pending Prepayment;FRA=Ouvert,Lancé,Approbation suspendue,Acompte suspendu
    value(0; "Open")
    {
        CaptionML = ENU = 'Open', FRA = 'Ouvert';
    }
    value(1; "Pending Approval")
    {
        CaptionML = ENU = 'Pending Approval', FRA = 'Approbation en attente';
    }
    value(2; Approved)
    {
        CaptionML = ENU = 'Approved', FRA = 'Approuvé';
    }
    value(3; "Refused")
    {
        CaptionML = ENU = 'Refused', FRA = 'Refuser';
    }
    value(4; "Released")
    {
        CaptionML = ENU = 'Released', FRA = 'Lancé';
    }
}