Enter the following in MySQL:

DECLARE @json NVARCHAR(4000)
SET @json = 
N'{
    "info":{
        "type":1,
        "address":{
            "town":"Bristol",
            "county":"Avon",
            "country":"England"
        },
        "tags":["Sport", "Water polo"]
    },
    "type":"Basic"
}'
