pageextension 50193 "VatEntry" extends "VAT Entries"
{
    layout
    {
        addafter("Bill-to/Pay-to No.")
        {
            field(NombreClienteProv; NombreClienteProv)
            {
                ApplicationArea = all;
                Caption = 'Nombre Cliente Proverdor';
            }
            field(Paisenvio; Paisenvio)
            {
                ApplicationArea = all;
                Caption = 'Pais Envío', comment = 'ESP="Pais Envío"';
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(actualizaPais)
            {
                ApplicationArea = all;
                Caption = 'Actualiza País', comment = 'ESP="Actualiza País"';
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    actualizaPaisEnvio();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        NombreClienteProv := '';
        if Vendor.get("Bill-to/Pay-to No.") then
            NombreClienteProv := Vendor.Name;

        if Customer.get("Bill-to/Pay-to No.") then
            NombreClienteProv := Customer.Name;

        Paisenvio := '';
        Paisenvio := GetPaisEnvio(Rec);

    end;

    procedure GetPaisEnvio(VatEntry: Record "VAT Entry"): Text;
    begin
        case VatEntry.Type of
            VatEntry.Type::Sale:
                Begin
                    case VatEntry."Document Type" of
                        VatEntry."Document Type"::Invoice:
                            begin
                                if HistFacVenta.Get("Document No.") then
                                    Exit(HistFacVenta."Ship-to Country/Region Code");
                            end;
                        VatEntry."Document Type"::"Credit Memo":
                            begin
                                if CRMemoSales.Get("Document No.") then
                                    Exit(CRMemoSales."Ship-to Country/Region Code");
                            end;
                        else
                            Exit('');
                    End;
                end
        end;
    end;

    var
        HistFacVenta: Record "Sales Invoice Header";
        CRMemoSales: Record "Sales Cr.Memo Header";
        NombreClienteProv: code[100];
        Paisenvio: text;

    procedure ActualizaPaisEnvio()
    var
        VatEntry: Record "VAT Entry";
        Pais: text;
    begin
        if VatEntry.findset() then
            repeat
                Pais := GetPaisEnvio(VatEntry);
                if VATEntry."Country/Region Code" = 'ES' then
                    if (Pais <> '') and (Pais <> VatEntry."Country/Region Code") then begin
                        VatEntry."Country/Region Code" := Pais;
                        VatEntry.Modify();
                    end;
            Until VatEntry.next() = 0;
    end;

}