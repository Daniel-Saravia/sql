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
SELECT 
    JSON_VALUE(@json, '$.type') as type,
    JSON_VALUE(@json, '$.info.address.town') as town,
    JSON_QUERY(@json, '$.info.tags') as tags
SELECT value
FROM OPENJSON(@json, '$.info.tags')
