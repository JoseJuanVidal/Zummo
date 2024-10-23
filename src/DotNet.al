dotnet
{
    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Net.Mail.SmtpClient"; MySmtpClient) { }
        type("System.Net.Mail.MailMessage"; MyMailMessage) { }
        type("System.Net.Mail.MailAddress"; MyMailAddress) { }
        type("System.Net.NetworkCredential"; MyNetworkCredential) { }
    }
    assembly(System.Data)
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
        type(System.Data.SqlClient.SqlConnection; SqlConnection) { }
        type(System.Data.SqlClient.SqlCommand; SqlCommand) { }
        type(System.Data.SqlClient.SqlDataReader; SqlDataReader) { }
        //     type(System.Data.DataTable; DataTable) { }
        //     type(System.Data.DataRow; DataRow) { }
        //     type(System.Data.DataColumn; DataColumn) { }
        //     type(System.Data.DataColumnCollection; DataColumnCollection) { }
        //     type(System.Data.DataRowCollection; DataRowCollection) { }
        //     type(System.Data.SqlClient.SqlParameter; SqlParameter) { }
        //     type(System.Data.SqlClient.SqlParameterCollection; SqlParameterCollection) { }
        //     type(System.Data.SqlClient.SqlConnectionStringBuilder; SqlConnectionStringBuilder) { }
        //     type(System.Data.SqlDbType; SqlDbType) { }
    }

    // assembly(System.Xml)
    // {
    //     //Version='4.0.0.0';
    //     //Culture='neutral';
    //     //PublicKeyToken='b77a5c561934e089';
    //     type(System.Xml.XmlNode; System_Xml_System_Xml_XmlNode) { }
    //     type(System.Xml.XmlAttribute; System_Xml_System_Xml_XmlAttribute) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlAttribute"
    //     type(System.Xml.XmlDocument; System_Xml_System_Xml_XmlDocument) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument"
    //     type(System.Xml.XmlNamedNodeMap; System_Xml_System_Xml_XmlNamedNodeMap) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNamedNodeMap"
    //     //type(System.Xml.XmlNode;System_Xml_System_Xml_XmlNode){} //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode"
    //     type(System.Xml.XmlNodeChangedEventArgs; System_Xml_System_Xml_XmlNodeChangedEventArgs) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeChangedEventArgs"
    //     type(System.Xml.XmlNodeList; System_Xml_System_Xml_XmlNodeList) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeList"
    //     type(System.Xml.Xsl.XslCompiledTransform; System_Xml_System_Xml_Xsl_XslCompiledTransform) { } //"'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.Xsl.XslCompiledTransform"
    // }
    assembly("Sothis.PDF")
    {

        Culture = 'neutral';
        PublicKeyToken = 'null';

        type("Sothis.PDF.Tools"; MySothisPDF) { }
    }
    assembly("mscorlib")
    {
        Version = '2.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Collections.Generic.List`1"; Myfiles) { }
    }
    // System.Collections.Generic.List`1.'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'    
}