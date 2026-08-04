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
                    CaptionClass = '1,2,1';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,2';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
                }
                field(GlobalDimension3; GlobalDimension3)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
                }
                field(GlobalDimension4; GlobalDimension4)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
                }
                field(GlobalDimension5; GlobalDimension5)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
                }
                field(GlobalDimension6; GlobalDimension6)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
                }
                field(GlobalDimension7; GlobalDimension7)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
                }
                field(GlobalDimension8; GlobalDimension8)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
                }
            }
        }
    }

    var
        CECOValue: code[20];
        Proyecto: code[20];
        GlobalDimension3: code[20];
        GlobalDimension4: code[20];
        GlobalDimension5: code[20];
        GlobalDimension6: code[20];
        GlobalDimension7: code[20];
        GlobalDimension8: code[20];


    // procedure GetCECOCOde(): code[20]
    // begin
    //     exit(CECOValue);
    // end;

    // procedure GetDim2COde(): code[20]
    // begin
    //     exit(Proyecto);
    // end;

    procedure GetDimCode(var dimGlobal1: Code[20]; var dimGlobal2: Code[20]; var dimGlobal3: Code[20]; var dimGlobal4: Code[20];
        var dimGlobal5: Code[20]; var dimGlobal6: Code[20]; var dimGlobal7: Code[20]; var dimGlobal8: Code[20])
    begin
        dimGlobal1 := CECOValue;
        dimGlobal2 := Proyecto;
        dimGlobal3 := GlobalDimension3;
        dimGlobal4 := GlobalDimension4;
        dimGlobal5 := GlobalDimension5;
        dimGlobal6 := GlobalDimension6;
        dimGlobal7 := GlobalDimension7;
        dimGlobal8 := GlobalDimension8;
    end;
}