---
title       : MongoDB Introduction II
author      : Ada Lee
framework   : io2012 
highlighter : highlight.js
hitheme     : tomorrow
url:
  lib: libraries
  assets: assets
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}

---

## Export a collection
### See collection colleagues before export

```find
Ada Desktop $ mongo
MongoDB shell version: 2.6.6
connecting to: test
> use company
switched to db company
> db.colleagues.find()
{ "_id" : 1, "name" : "Bob", "gender" : "Male" }
{ "_id" : 2, "name" : "Johanne", "gender" : "Female" }
{ "_id" : 3, "name" : "Michael", "gender" : "Male" }
{ "_id" : 4, "name" : "Emily", "gender" : "Female" }
{ "_id" : 5, "name" : "Amy", "gender" : "Female" }
{ "_id" : 6, "name" : "Ada", "gender" : "Female" }
> ^C
bye
Ada Desktop $
```

---

## Export a collection
### Export collection colleagues

```export
Ada Desktop $ ls colleagues.json
ls: colleagues.json: No such file or directory
Ada Desktop $ mongoexport --db company  --collection colleagues --out colleagues.json
connected to: 127.0.0.1
exported 6 records
Ada Desktop $ ls colleagues.json
colleagues.json
Ada Desktop $ cat colleagues.json
{ "_id" : 1, "name" : "Bob", "gender" : "Male" }
{ "_id" : 2, "name" : "Johanne", "gender" : "Female" }
{ "_id" : 3, "name" : "Michael", "gender" : "Male" }
{ "_id" : 4, "name" : "Emily", "gender" : "Female" }
{ "_id" : 5, "name" : "Amy", "gender" : "Female" }
{ "_id" : 6, "name" : "Ada", "gender" : "Female" }
Ada Desktop $ 
```

---

## Import a collection

### use mongoimport to import colleagues.json

```import
Ada Desktop $ mongoimport --db company_backup --collection colleagues < colleagues.json
connected to: 127.0.0.1
2015-05-26T22:34:09.493+0800 imported 6 objects
```

---

## Import a collection
### look at the database company_backup

```company_backup
Ada Desktop $ mongo
MongoDB shell version: 2.6.6
connecting to: test
> use company_backup
switched to db company_backup
> show collections
colleagues
system.indexes
> db.colleagues.find()
{ "_id" : 1, "name" : "Bob", "gender" : "Male" }
{ "_id" : 2, "name" : "Johanne", "gender" : "Female" }
{ "_id" : 3, "name" : "Michael", "gender" : "Male" }
{ "_id" : 4, "name" : "Emily", "gender" : "Female" }
{ "_id" : 5, "name" : "Amy", "gender" : "Female" }
{ "_id" : 6, "name" : "Ada", "gender" : "Female" }
>
```

---

## Some operations

### count

```
> db.colleagues.count()
6
> db.colleagues.find( { gender : "Female" } ).count()
4
```

### distinct

```
> db.colleagues.distinct("gender")
[ "Male", "Female" ]
```

---
## Some operations

### pretty

```
> db.colleagues.findOne( { name : "Ada" } )
{
        "_id" : 6,
        "name" : "Ada",
        "gender" : "Female"
}
> db.colleagues.find( { name : "Ada" } )
{ "_id" : 6, "name" : "Ada", "gender" : "Female" }
> db.colleagues.find( { name : "Ada" } ).pretty()
{
        "_id" : 6,
        "name" : "Ada",
        "gender" : "Female"
}
```

---

## Some operations

### limit

```
> db.colleagues.find().limit(2)
{ "_id" : 1, "name" : "Bob", "gender" : "Male" }
{ "_id" : 2, "name" : "Johanne", "gender" : "Female" }
> db.colleagues.find().limit(2).pretty()
{
        "_id" : 1,
        "name" : "Bob",
        "gender" : "Male"
}
{
        "_id" : 2,
        "name" : "Johanne",
        "gender" : "Female"
}
```

---

## Some operations

### skip

```
> db.colleagues.find().skip(2)
{ "_id" : 3, "name" : "Michael", "gender" : "Male" }
{ "_id" : 4, "name" : "Emily", "gender" : "Female" }
{ "_id" : 5, "name" : "Amy", "gender" : "Female" }
{ "_id" : 6, "name" : "Ada", "gender" : "Female" }
> db.colleagues.find().skip(2).limit(1)
{ "_id" : 3, "name" : "Michael", "gender" : "Male" }
> db.colleagues.find().skip(2).limit(1).pretty()
{
        "_id" : 3,
        "name" : "Michael",
        "gender" : "Male"
}
```

---
## Some operations

### sort

```
> db.colleagues.find( { } , { _id : 0 } )
{ "name" : "Bob", "gender" : "Male" }
{ "name" : "Johanne", "gender" : "Female" }
{ "name" : "Michael", "gender" : "Male" }
{ "name" : "Emily", "gender" : "Female" }
{ "name" : "Amy", "gender" : "Female" }
{ "name" : "Ada", "gender" : "Female" }

> db.colleagues.find( { } , { _id : 0 } ).sort( { name : -1 } )
{ "name" : "Michael", "gender" : "Male" }
{ "name" : "Johanne", "gender" : "Female" }
{ "name" : "Emily", "gender" : "Female" }
{ "name" : "Bob", "gender" : "Male" }
{ "name" : "Amy", "gender" : "Female" }
{ "name" : "Ada", "gender" : "Female" }

```

---
## Aggregate

### project

```project
> db.colleagues.aggregate([
...     {$project:
...       {
...         _id: 0,
...         name: 1,
...         gender: 1,
...       } 
...     }      
... ])
{ "name" : "Bob", "gender" : "Male" }
{ "name" : "Johanne", "gender" : "Female" }
{ "name" : "Michael", "gender" : "Male" }
{ "name" : "Emily", "gender" : "Female" }
{ "name" : "Amy", "gender" : "Female" }
{ "name" : "Ada", "gender" : "Female" }
```

---

## Aggregate

### match

```match
> db.colleagues.aggregate([
...     {$match:
...       {
...         gender : "Female"
...       }
...     }
... ])
{ "_id" : 2, "name" : "Johanne", "gender" : "Female" }
{ "_id" : 4, "name" : "Emily", "gender" : "Female" }
{ "_id" : 5, "name" : "Amy", "gender" : "Female" }
{ "_id" : 6, "name" : "Ada", "gender" : "Female" }
```

---

## Aggregate

### group sum

```group
> db.colleagues.aggregate([
... { $group:
...          {
...              _id:"$gender",
...              total: { $sum : 1 }
...          }
... }
... ])
{ "_id" : "Female", "total" : 4 }
{ "_id" : "Male", "total" : 2 }
```

---

## Aggregate

### group min

```
> db.colleagues.aggregate([
...     {$group:
...       {
...         _id: "$gender",
...         min_name: {$min: "$name"}
...       } 
...     }          
... ])
{ "_id" : "Female", "min_name" : "Ada" }
{ "_id" : "Male", "min_name" : "Bob" }
```

---

## Aggregate  

### group max
```
> db.colleagues.aggregate([
...     {$group:
...       {
...         _id: "$gender",
...         min_name: {$max: "$name"}
...       } 
...     }          
... ])
{ "_id" : "Female", "min_name" : "Johanne" }
{ "_id" : "Male", "min_name" : "Michael" }
```

---

## Aggregate

### sort

```
> db.colleagues.aggregate([
...     {$sort:
...       {
...         name: -1
...       } 
...     }          
... ])
{ "_id" : 3, "name" : "Michael", "gender" : "Male" }
{ "_id" : 2, "name" : "Johanne", "gender" : "Female" }
{ "_id" : 4, "name" : "Emily", "gender" : "Female" }
{ "_id" : 1, "name" : "Bob", "gender" : "Male" }
{ "_id" : 5, "name" : "Amy", "gender" : "Female" }
{ "_id" : 6, "name" : "Ada", "gender" : "Female" }
```

---

## Aggregate
### pipeline 1

```
> db.colleagues.aggregate([
...  {$project:
...       {
...         _id : 0,
...         name : 1,
...         gender : 1
...       } 
...     }
... ])
{ "name" : "Bob", "gender" : "Male" }
{ "name" : "Johanne", "gender" : "Female" }
{ "name" : "Michael", "gender" : "Male" }
{ "name" : "Emily", "gender" : "Female" }
{ "name" : "Amy", "gender" : "Female" }
{ "name" : "Ada", "gender" : "Female" }
```

---

## Aggregate

### pipeline 2

```
> db.colleagues.aggregate([
...  {$project:
...       {
...         _id : 0,
...         name : 1,
...         gender : 1
...       } 
...     },
...     {$match:
...       {
...         gender: "Male"
...       } 
...     }
... ])
{ "name" : "Bob", "gender" : "Male" }
{ "name" : "Michael", "gender" : "Male" }
```

---

## Aggregate

### pipeline 3

```
> db.colleagues.aggregate([
... {$project:
...       { _id : 0, name : 1, gender : 1 } 
...     },
...     {$match:
...       { gender: "Male" } 
...     },
...     {$group:
...       { _id : null, total_male : { "$sum" : 1 } } 
...     },          
... ])
{ "_id" : null, "total_male" : 2 }
```



                        



