// report 50120 "Matriculas Maquinas"
// {
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = './src/report/Rep50120.MatriculasMaquinas.rdl';
//     Caption = 'Etiqueta De Expedicion', Comment = 'Etiqueta De Expedicion';
//     PreviewMode = PrintLayout;
//     UsageCategory = ReportsAndAnalysis;
//     EnableHyperlinks = true;

//     dataset
//     {
//         dataitem(NumEtiquetas; Integer)
//         {
//             DataItemTableView = where(Number = const(1));
//             column(lblSerialNo; 'SN: ' + SerialNo) { }
//             column(SerialNo; SerialNo) { }
//             column(NumeroEtiquetas; NumeroEtiquetas) { }
//             column(Number; Number) { }
//             column(BarCodeSerialNo; '*' + SerialNo + '*') { }
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options', comment = 'ESP="Opciones"';
//                     field(SerialNo; SerialNo)
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Serial No.', comment = 'ESP="Nº Serie"';
//                     }
//                     field(NumeroEtiquetas; NumeroEtiquetas)
//                     {
//                         ApplicationArea = all;
//                         Caption = 'Number of labels', comment = 'ESP="Número Etiquetas"';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//             area(processing)
//             {
//                 action(LayoutName)
//                 {

//                 }
//             }
//         }
//     }

//     trigger OnInitReport()
//     begin
//         NumeroEtiquetas := 1;
//         NumEtiquetas.SetRange(Number, 1);
//     end;

//     var
//         SerialNo: code[50];
//         NumeroEtiquetas: Integer;
// }