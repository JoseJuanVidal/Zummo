// pageextension 60000 "STH Item Ext" extends "Item List"
// {
//     actions
//     {
//         addlast(Processing)
//         {
//             group(STHAcciones)
//             {
//                 Caption = 'Acciones';
//                 action("STH Get JSON")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Get JSON';
//                     Image = GetEntries;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;

//                     trigger OnAction()
//                     var
//                         zummoFunctions: Codeunit "STH Zummo Functions";
//                         JsonText: Text;
//                     begin
//                         SetSelectionFilter(Rec);
//                         repeat
//                             JsonText := zummoFunctions.GetJSON_Item(Rec);
//                             zummoFunctions.PutBody(JsonText, Rec);
//                         until Rec.Next() = 0;
//                     end;
//                 }
//             }
//         }
//     }

// }
