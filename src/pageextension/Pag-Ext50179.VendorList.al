pageextension 50179 "VendorList" extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field(ClasProveedor_btc; ClasProveedor_btc) { }
            field("Payment Method Code"; "Payment Method Code") { }
            field("VAT Registration No."; "VAT Registration No.")
            {
                ApplicationArea = all;
            }
            field("Net Change"; "Net Change")
            {
                ApplicationArea = All;
            }
            field("Net Change (LCY)"; "Net Change (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addbefore("Entry Statistics")
        {
            action("Imprimir Extracto")
            {
                ApplicationArea = All;
                Caption = 'Imprimir Extracto', comment = 'NLB="Imprimir Extracto"';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintForm;
                trigger OnAction()
                var
                    Proveedor: Record Vendor;
                begin
                    Proveedor.SetRange("No.", Rec."No.");
                    if (Proveedor.FindFirst()) then
                        Report.Run(Report::"Extracto Proveedor", true, false, Proveedor);
                end;
            }
            action(MatrizProductos)
            {
                ApplicationArea = all;
                Caption = 'Matriz Productos', comment = 'ESP="Matriz Productos"';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page PageMatricesComprasProducto;
            }
            action(MatrizProveedor)
            {
                ApplicationArea = all;
                Caption = 'Matriz Proveedor', comment = 'ESP="Matriz Proveedor"';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page PageMatricesComprasProovedor;
            }
        }

    }

}


