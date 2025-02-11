-- Step 1: Create the table to hold pet information
CREATE TABLE Pets (
    PetID INT PRIMARY KEY,
    Name VARCHAR(50),
    Category VARCHAR(50),
    Breed VARCHAR(50),
    DateAdopted DATE,
    Gender VARCHAR(10),
    Registered VARCHAR(50) NULL,  -- NULL if not present
    Color VARCHAR(50),
    ListPrice DECIMAL(10,2)
);

-- Step 2: Assume the XML content (without prolog and stylesheet) is loaded into an XML variable.
DECLARE @xml XML = 
N'<Pets>
  <Pet PetID="7">
    <Name>Eugene</Name>
    <Category>Cat</Category>
    <Breed>Siamese</Breed>
    <DateAdopted>01/25/2011</DateAdopted>
    <Gender>Male</Gender>
    <Registered>CFA</Registered>
    <Color>Black</Color>
    <ListPrice>$279.54</ListPrice>
  </Pet>
  <!-- (Include all other Pet elements here exactly as in pets.xml) -->
  <Pet PetID="43">
    <Name>Chelsea</Name>
    <Category>Reptile</Category>
    <Breed>Python</Breed>
    <DateAdopted>02/10/2011</DateAdopted>
    <Gender>Female</Gender>
    <Color>Black/Gold</Color>
    <ListPrice>$237.90</ListPrice>
  </Pet>
</Pets>';

-- Step 3: Insert the data into the table by “shredding” the XML
INSERT INTO Pets (PetID, Name, Category, Breed, DateAdopted, Gender, Registered, Color, ListPrice)
SELECT
    T.C.value('@PetID', 'INT') AS PetID,
    T.C.value('Name[1]', 'VARCHAR(50)') AS Name,
    T.C.value('Category[1]', 'VARCHAR(50)') AS Category,
    T.C.value('Breed[1]', 'VARCHAR(50)') AS Breed,
    CONVERT(DATE, T.C.value('DateAdopted[1]', 'VARCHAR(20)'), 101) AS DateAdopted,
    T.C.value('Gender[1]', 'VARCHAR(10)') AS Gender,
    T.C.value('Registered[1]', 'VARCHAR(50)') AS Registered,
    T.C.value('Color[1]', 'VARCHAR(50)') AS Color,
    CAST(REPLACE(T.C.value('ListPrice[1]', 'VARCHAR(20)'), '$', '') AS DECIMAL(10,2)) AS ListPrice
FROM @xml.nodes('/Pets/Pet') T(C);
