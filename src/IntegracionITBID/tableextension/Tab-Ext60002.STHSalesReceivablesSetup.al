// tableextension 60002 "STH Sales & Receivables Setup" extends "Sales & Receivables Setup"
// {
//     fields
//     {
//         field(60002; STHurlAccessToken; Text[250])
//         {
//             Caption = 'URL Access Token';
//             DataClassification = CustomerContent;
//         }
//         field(60003; STHurlPut; Text[250])
//         {
//             Caption = 'URL Put';
//             DataClassification = CustomerContent;
//         }
//         field(60004; "STHRequires Authentication"; Boolean)
//         {
//             Caption = 'Requires Authenticacion';
//             DataClassification = CustomerContent;
//             InitValue = true;
//         }
//         field(60005; "STHclient_id"; Text[250])
//         {
//             Caption = 'client_id';
//             DataClassification = CustomerContent;
//             ExtendedDatatype = Masked;
//         }
//         field(60006; "STHclient_secret"; Text[250])
//         {
//             Caption = 'client_secret';
//             DataClassification = CustomerContent;
//             ExtendedDatatype = Masked;
//         }
//         field(60007; "STHgrant_type"; Text[30])
//         {
//             Caption = 'grant_type';
//             DataClassification = CustomerContent;
//             ExtendedDatatype = Masked;
//         }
//         field(60008; "STHredirect_url"; Text[100])
//         {
//             Caption = 'redirect_url';
//             DataClassification = CustomerContent;
//             ExtendedDatatype = Masked;
//         }
//         field(60009; STHusername; Text[50])
//         {
//             Caption = 'username';
//             DataClassification = CustomerContent;
//             ExtendedDatatype = Masked;
//         }
//         field(60010; STHpassword; Text[50])
//         {
//             Caption = 'password';
//             DataClassification = CustomerContent;
//             ExtendedDatatype = Masked;
//         }
//         field(60011; STHemail; Text[100])
//         {
//             Caption = 'email';
//             DataClassification = CustomerContent;
//         }
//     }

//     var
//         myInt: Integer;
// }