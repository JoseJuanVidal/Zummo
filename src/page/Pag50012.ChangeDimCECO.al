page 50012 "Change Dim CECO"
{
    Caption = 'Cambiar Dimensiones Multiple', comment = 'ESP="Cambiar Dimensiones Multiple"';
    PageType = StandardDialog;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    //SourceTable = TableName;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(CECOValue; CECOValue)
                {
                    ApplicationArea = All;
                    Caption = 'CECO', comment = 'ESP="CECO"';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = All;
                    Caption = 'Proyecto', comment = 'ESP="Proyecto"';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
                }
            }
        }
    }

    var
        CECOValue: code[20];
        Proyecto: code[20];

    procedure GetCECOCOde(): code[20]
    begin
        exit(CECOValue);
    end;

    procedure GetDim2COde(): code[20]
    begin
        exit(Proyecto);
    end;

}