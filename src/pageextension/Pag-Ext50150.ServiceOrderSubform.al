pageextension 50150 "ServiceOrderSubform" extends "Service Order Subform"
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
        }
        addlast(Control1)
        {
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
        addafter("Service Lines")
        {
            action(Lines)
            {
                ApplicationArea = all;
                Caption = 'Services All', comment = 'ESP="Todos los servicios"';
                Image = AllLines;

                trigger OnAction()
                var
                    ServInvLine: Record "Service Line";
                    ServInvLines: page "Service Line List";
                begin
                    TESTFIELD("Document No.");
                    CLEAR(ServInvLine);
                    ServInvLine.SETRANGE("Document Type", "Document Type");
                    ServInvLine.SETRANGE("Document No.", "Document No.");
                    ServInvLine.FILTERGROUP(2);
                    CLEAR(ServInvLines);
                    ServInvLines.Editable := true;
                    ServInvLines.SETTABLEVIEW(ServInvLine);
                    ServInvLines.RUNMODAL;
                    ServInvLine.FILTERGROUP(0);
                end;
            }
        }
    }
}