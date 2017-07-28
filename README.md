# Swift Plugin

BU Analytics plugin for Swift compatible with iOS, macOS, tvOS, watchOS and Linux.

Please visit our [BU Analytics](http://bu-games.bmth.ac.uk) website for more information.

## Installation

To install the plugin you must copy the [BUAnalytics](BUAnalytics) folder into your Xcode project.

## Authentication

To authenticate with the backend you must first create an access key through the web management interface. 
Then pass these details into the api singleton instance.

```swift
BUAPI.instance.auth = BUAccessKey(key: "58ac40d0126553000c426f92", secret: "9a48ab9ac420c0b7f0ed477bb7f56b267477bb808b5ec4d2dddb7e39a57e6f4a")
```

## Getting Started

You can use the convenience method to quickly add a document to a collection which will be created if needed.

```swift
BUCollectionManager.instance.append(collection: "Users", document: [
    "userId": ..,
    "name": ..,
    "age": ..,
    "gender": ..,
    "device": [
        "type": ..,
        "name": ..,
        "model": ..
    ]
])
```

If you would like to manage your own collections and documents please see below.

## Creating Collections

We must then create the collections that we would like to use throughout the application. 
This can be done at any point and as many times as needed however collections will not be overwritten if created with a duplicate names.

```swift
BUCollectionManager.instance.create(names: [
    "Users",
    "Sessions",
    "Clicks"
])
```

## Creating a Document

We can create a document using a dictionary literal that allows for as many nested values as needed. 
Documents support nested dictionaries, arrays and will encode literal data types when uploading to the backend server.

```swift
let userDoc = BUDocument(contents: [
    "userId": ..,
    "name": ..,
    "age": ..,
    "gender": ..,
    "device": [
        "type": ..,
        "name": ..,
        "model": ..
    ]
])
```

You can also create documents through the add method or can access the raw dictionary object through the contents property.

```swift
let userDoc = BUDocument()

userDoc.append("userId", value: ..)
userDoc.append("name", value: ..)

userDoc.contents["age"] = ..
userDoc.contents["gender"] = ..
```

## Adding a Document to Collection

You can then add one or more documents to a collection through the collection manager.

```swift
BUCollectionManager.instance.collections["Users"]!.append(document: userDoc)
BUCollectionManager.instance.collections["Users"]!.append(documents: [ userDoc1, userDoc2, userDoc3 ])
```

Collections will automatically push all documents to the backend server every two seconds if not empty. 
You can also manually initiate an upload either on all or a specific collection.

```swift
BUCollectionManager.instance.uploadAll()
BUCollectionManager.instance.collections["Users"]!.upload()
```

You can also use the interval property to configure how often collections are uploaded in milliseconds. 
The default is 2000 milliseconds and setting it to 0 will disable automatic uploads.

```swift
BUCollectionManager.instance.interval = 4000
```

## Error Handling

You can subscribe to actions in the collection manager to notify you when collections upload successfully or return errors.

```swift
BUCollectionManager.instance.error = { (collection, code) in
	//...
}
 
BUCollectionManager.instance.success = { (collection, count) in
	//...
}
```

You can also provide error and success actions to an individual collection using the upload method.

## Unique Identifiers

You can use our backend to generate unique identifiers for use inside documents. 
Setup the cache at startup specifying how many identifiers you'd like to hold.

```swift
BUID.instance.start(200)
```

Once the cache has been marked as ready you can generate identifiers at any time.

```swift
if BUID.instance.isReady{
	userDoc.append("userId", BUID.instance.generate())
}
```

You can modify the refresh frequency or size of the cache depending on how many identifiers you require. 
GUIDs will be generated as a backup should the cache become empty.

```swift
BUID.instance.interval = 4000
BUID.instance.size = 100
```

## Advanced

The hostname defaults to the bu analytics server although we can change this if necessary.

```swift
BUAPI.instance.url = "http://192.168.0.x"
BUAPI.instance.path = "/api/v1"
```