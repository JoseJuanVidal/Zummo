pageextension 50077 "ZM Service Item Lines" extends "Service Item Lines"
{
    layout
    {
        addafter("Serial No.")
        {
            field(CodAnterior_btc; CodAnterior_btc)
            {
                ApplicationArea = All;
            }
        }
        addafter("Symptom Code")
        {
            field(CodProdFallo_btc; CodProdFallo_btc)
            {
                ApplicationArea = All;
            }

            field(NumCiclos_btc; NumCiclos_btc)
            {
                ApplicationArea = All;
            }
        }
        addafter(Warranty)
        {
            field(AmpliacionGarantia_sth; AmpliacionGarantia_sth)
            {
                ApplicationArea = All;
            }
            field(FechaFinGarantia_sth; FechaFinGarantia_sth)
            {
                ApplicationArea = All;
            }
            field(Fecharecepaviso_sth; Fecharecepaviso_sth)
            {
                ApplicationArea = all;
            }
            field(Fechaemtregamaterial_sth; Fechaemtregamaterial_sth)
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field(Fallo; Fallo)
            {
                ApplicationArea = all;
            }
            field("Fallo localizado"; "Fallo localizado")
            {
                ApplicationArea = all;
            }
            field("Informe Mejora"; "Informe Mejora")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addlast(Navigation)
        {
            action(ShowDocument)
            {
                ApplicationArea = all;
                Caption = 'Mostrar Documento', comment = 'ESP="Mostrar Documento"';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    ShowDocuments;
                end;

            }
        }
    }

    local procedure ShowDocuments()
    var
        ServiceHeader: Record "Service Header";
        ServiceOrder: Page "Service Order";
    begin
        ServiceHeader.Reset();
        ServiceHeader.SetRange("Document Type", Rec."Document Type");
        ServiceHeader.SetRange("No.", Rec."Document No.");
        ServiceOrder.SetTableView(ServiceHeader);
        ServiceOrder.RunModal;
    end;

}
