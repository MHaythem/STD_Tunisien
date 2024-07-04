enum 50253 "Action Type"
{
    Extensible = true;

    value(0; " ")
    {
        CaptionML = ENU = '', FRA = '';
    }
    value(1; Purchase)
    {
        CaptionML = ENU = 'Purchase Order', FRA = 'Commande Achat';
    }
    value(2; "Transfer Order")
    {
        CaptionML = ENU = 'Transfer Order', FRA = 'Ordre de transfert';
    }
    value(3; "Blanket Order")
    {
        CaptionML = ENU = 'Blanket Order', FRA = 'Contrat achat';
    }
    value(4; "Purchase Quote")
    {
        CaptionML = ENU = 'Purchase Quote', FRA = 'demande prix';
    }

}