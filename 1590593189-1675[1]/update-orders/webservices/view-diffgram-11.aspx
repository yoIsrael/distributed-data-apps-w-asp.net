<%@Page Language="C#" ValidateRequest="False" Debug="True"%>
<%@Import Namespace="System.Data" %>
<%@Import Namespace="System.Xml" %>
<%@Register TagPrefix="dda" TagName="showdataset"
            Src="..\..\global\show-dataset.ascx" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html><head>
<title>View the Edited DiffGram</title>
<!-- #include file="..\..\global\style.inc" -->
</head>
<body link="#0000ff" alink="#0000ff" vlink="#0000ff">
<div class="heading">View the Edited DiffGram</div>
<div align="right" class="cite">
[<a href="../../global/viewsource.aspx">view page source</a>]
</div><hr />

<div id="outError" runat="server"></div><p />

<b>DataSet Tables Collection:</b>
<asp:Datagrid id="dgr1" runat="server" /><p />

<!-- insert custom controls to display values -->
<dda:showdataset id="ctlShow1" runat="server" />
<dda:showdataset id="ctlShow2" runat="server" /><p />

<b>Posted XML Content:</b>
<div id="outXML" runat="server"></div><p />

<!--------------------------------------------------------------------------->

<script Language="C#" runat="server">

void Page_Load() {

  // create a new DataSet object
  DataSet objDataSet = new DataSet();

  try {

    // create an XmlTextReader to read data sent from client
    // specifying that string fragment is an XML Document
    XmlTextReader objReader = new XmlTextReader(Request.Form["hidPostXML"],
                                                XmlNodeType.Document, null);

    // read the schema into the DataSet from file on disk
    // must use the Physical path to the file not the Virtual path
    objDataSet.ReadXmlSchema(Request.MapPath("orders-schema.xsd"));

    // read in the DiffGram posted from the client
    objDataSet.ReadXml(objReader);

  }
  catch (Exception objError) {

    // display error details
    outError.InnerHtml = "<b>* Error while reading disk file</b>.<br />"
                       + objError.Message + " " + objError.Source;
  }

  // -------------- show contents of DataSet ----------------

  try {

    // bind DataGrid control to DataSet Tables collection
    dgr1.DataSource = objDataSet.Tables;
    dgr1.DataBind();

    // display Orders current and original values after loading
    DataTable objTable = objDataSet.Tables["Orders"];
    ctlShow1.ShowValues(objTable, "Orders row values after loading DiffGram");

    // display Order Details current and original values
    objTable = objDataSet.Tables["Order Details"];
    ctlShow2.ShowValues(objTable, "Order Details row values after loading DiffGram");

  }
  catch (Exception objError) {}

  // display the XML DiffGram itself
  outXML.InnerHtml = "<xmp>" + Request.Form["hidPostXML"] + "</xmp>";

}
</script>

<!--------------------------------------------------------------------------->
<!-- #include file="..\..\global\foot.inc" -->
</body>
</html>
