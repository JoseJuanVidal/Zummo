pageextension 50199 "PostedPurchaseInvoiceLines" extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field(ShortcutDimCode3; ShortcutDimCode[3])
            {
                CaptionClass = '1,2,3';
             }
            field(ShortcutDimCode4; ShortcutDimCode[4])
            {
                CaptionClass = '1,2,4';
            }

            field(ShortcutDimCode5; ShortcutDimCode[5])
            {
                CaptionClass = '1,2,5';
            }

            field(ShortcutDimCode6; ShortcutDimCode[6])
            {
                CaptionClass = '1,2,6';
            }

            field(ShortcutDimCode7; ShortcutDimCode[7])
            {
                CaptionClass = '1,2,7';
            }

            field(ShortcutDimCode8; ShortcutDimCode[8])
            {
                CaptionClass = '1,2,8';
            }




        }
    }
    trigger OnAfterGetRecord()

    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
}