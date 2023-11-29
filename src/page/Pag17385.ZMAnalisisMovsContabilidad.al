page 17385 "ZM Analisis Movs Contabilidad"
{
    Caption = 'Análisis Movs. Contabilidad', comment = 'ESP="Análisis Movs. Contabilidad"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "G/L Entry";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(CtaContable; CtaContable)
                {
                    ApplicationArea = All;
                    Caption = 'Nº cuenta', comment = 'ESP="Nº cuenta"';
                    TableRelation = "G/L Account";
                }
                field(FiltroFecha; FiltroFecha)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Fecha', comment = 'ESP="Filtro Fecha"';
                }
            }
            repeater(GLEntry)
            {
                Editable = false;
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
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
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Bill No."; "Bill No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
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
                field("Global Dimension 3 Code"; "Global Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 8 Code"; "Global Dimension 8 Code")
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
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Additional-Currency Amount"; "Additional-Currency Amount")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
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
                field("FA Entry Type"; "FA Entry Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Editable = false;
                }
                field("FA Entry No."; "FA Entry No.")
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
                field("Period Trans. No."; "Period Trans. No.")
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
        if Vendor.Get(Rec."Source No.") then
            Rec."Customer Name" := Vendor.Name;
    end;

    var
        Vendor: Record Vendor;
        Funciones: Codeunit Funciones;
        CtaContable: code[20];
        FiltroFecha: text;

    local procedure LoadGlEntry()
    var
        myInt: Integer;
    begin
        Rec.DeleteAll();
        CurrPage.Update();
        Funciones.LoadGlEntry(Rec, CtaContable, FiltroFecha);
    end;
}