# Swift Plugin

BU Analytics Swift plugin.

## Installation

To install the plugin you must copy the [BUAnalytics](BUAnalytics) folder into your Xcode project.

## Authentication

To authenticate with the backend you must first create an access key through the web management interface. Then pass these details into the api singleton instance.

```swift
BGAPI.instance.auth = BGAccessKey(key: "585913d39dd4c40001c12920", secret: "7BbQYgXi21A56D8ofOypaIkJDUjqoo")
```

The hostname defaults to the university server although we can change this if necessary.

```swift
BGAPI.instance.url = "http://192.168.0.22"
BGAPI.instance.url = "/api/v1"
```

## Creating Collections

We must then create the collections that we would like to use throughout the application. This can be done at any point and as many times as needed however collections will not be overwritten if created with a duplicate names.

```swift
BGCollectionManager.instance.create(names: [
    "Users",
    "Sessions",
    "Clicks"
])
```

## Creating a Document

We can create a document using a dictionary literal that allows for as many nested values as needed. Documents support nested dictionaries, arrays and will encode literal data types when uploading to the backend server.

```swift
let userDoc = BGDocument(contents: [
    "userId": Utility.userId as Any,
    "name": nameField.stringValue,
    "age": age,
    "gender": gender.rawValue,
    "device": [
        "type": "Desktop",
        "name": Host.current().localizedName,
        "model": Sysctl.model
    ]
])
```

You can also create documents through the add method or can access the raw dictionary object through the contents property.

```swift
let userDoc = BGDocument()
userDoc.append("userId", value: userId)
userDoc.append("name", value: nameField.text)
userDoc.append("age", value: age)
userDoc.append("gender", value: gender)
```

## Adding a Document to Collection

You can then add one or more documents to a collection through the collection manager.

```swift
BGCollectionManager.instance.collections["Users"]!.append(document: userDoc)
BGCollectionManager.instance.collections["Users"]!.append(documents: [ userDoc1, userDoc2, userDoc3 ])
```

Collections will automatically push all documents to the backend server every two seconds if not empty. You can also manually initiate an upload either on all or a specific collection.

```swift
BGCollectionManager.instance.uploadAll()
BGCollectionManager.instance.collections["Users"]!.upload()
```

You can also use the interval property to configure how often collections are uploaded in milliseconds. The default is 2000 milliseconds and setting it to 0 will disable automatic uploads.

```swift
BGCollectionManager.instance.interval = 4000
```

## Error Handling

You can subscribe to actions in the collection manager to notify you when collections upload successfully or return errors.

```swift
BGCollectionManager.instance.error = { (collection, code) in
  //...
}
 
BGCollectionManager.instance.success = { (collection, count) in
  //...
}
```

You can also provide error and success actions to an individual collection using the upload method.