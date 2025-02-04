use OPENXMLTesting;
Create Table XMLwithOpenXML
(
	XMLwithOpenXML_id INT Identity primary key,
	XMLData XML,
	LoadedDateTime Datetime

);

Insert Into XMLwithOpenXML (XMLData, LoadedDateTime)
Select Convert(XML, BulkColumn) As BulkColumn, GETDATE()
From OPENROWSET (BULK 'C:\Users\rdp_user\Documents\OpenXMLTesting.xml',
SINGLE_BLOB) AS x;
