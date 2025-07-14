page 17401 "ZM Analysis Ldg. Fixed Assets"
{
    Caption = 'Analysis Ldg. Fixed Assets', comment = 'ESP="Análisis Movs. Activos Fijos"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FA Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(FixedAsset; FixedAsset)
                {
                    ApplicationArea = All;
                    Caption = 'Nº Fixed Asset', comment = 'ESP="Nº Activo Fijo"';
                    TableRelation = "Fixed Asset";
                }
                field(FiltroFecha; FiltroFecha)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Fecha', comment = 'ESP="Filtro Fecha"';
                }
            }
            repeater(Lines)
            {
                Editable = false;
                field("FA Posting Date"; "FA Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("FA No."; "FA No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(FAName; FixedAssets.Description)
                {
                    Caption = 'Fixed Assets Name', comment = 'ESP="Nombre Act. Fijo"';
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Depreciation Book Code"; "Depreciation Book Code")
                {
                    ApplicationArea = all;
                }
                field("FA Posting Category"; "FA Posting Category")
                {
                    ApplicationArea = all;
                }
                field("FA Posting Type"; "FA Posting Type")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                }
                field("Reclassification Entry"; "Reclassification Entry")
                {
                    ApplicationArea = all;
                }
                field("No. of Depreciation Days"; "No. of Depreciation Days")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("G/L Entry No."; "G/L Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gen. Posting Type"; "Gen. Posting Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("VAT Amount"; "VAT Amount")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Reversed Entry No."; "Reversed Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Reversed by Entry No."; "Reversed by Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Cargar)
            {
                ApplicationArea = All;
                Caption = 'Visualizar', comment = 'ESP="Visualizar"';
                Image = LaunchWeb;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    LoadGlEntry();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not FixedAssets.Get(Rec."FA No.") then
            Clear(FixedAssets);
    end;

    var
        FixedAssets: Record "Fixed Asset";
        Funciones: Codeunit Funciones;
        FixedAsset: code[20];
        FiltroFecha: text;

    local procedure LoadGlEntry()
    begin
        Rec.DeleteAll();
        CurrPage.Update();
        Funciones.LoadFixedAssetLedgerEntry(Rec, FixedAsset, FiltroFecha);
    end;

    procedure SetFixedAsset(FixedAssetNo: code[20])
    begin
        FixedAsset := FixedAssetNo;
        LoadGlEntry();
    end;
}