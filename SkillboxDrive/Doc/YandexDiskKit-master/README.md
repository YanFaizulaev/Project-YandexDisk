# *Unofficial* Yandex Disk SDK in swift #

### What is this? ###

A pleasant wrapper around the Yandex Disk API.
The SDK implements the whole range of functionality included in the
public API as a swift Framework. It was implemented with type safety
and error handling in mind.

The framework is accompanied by an sample iOS application which is
also written in swift. At the time of writing the application supports
browsing the disk, publishing, un-publishing and deleting elements.
The application is written to be universal for iPhone and iPad of all sizes.

## Required reading

Please check out:

* the [Yandex Disk API page][DISKAPI],
* the [Yandex OAuth 2 API page][AUTHAPI],
* and the [API Terms of Use][APITERMS]

## Installing

### Register for an Yandex API key.

You can register your app at the: [Yandex OAuth app registration page][REGISTER].

### Include the code

Add the YandexDiskKit xcodeproj to your project/workspace,
~~or copy the YandexDiskKit source code into your Xcode project~~.

## Using the SDK

You will need to have a valid OAuth token before you can start.

### Initializing

The disk object has needs to be initialized with the OAuth token:
```
let disk = YandexDisk(token: "0123456789abcdef0123456789abcdef")
```

### Listing a folder

Listing asynchronously by using a completion handler:
```
disk.listPath(root) { response in

    switch response {
    case .File(let file):
        // ...
    case let .Listing(dir, limit, offset, total, path, sort, items):
        // ...
    case .Failed(let error):
        // ...
    }
}
```

Listing synchronously by using the result future:
```
let response = disk.listPath(.Disk("")) // the root path

switch response.get() {    // the `get()` blocks till the result is available
case .File(let file):
    // ...
case let .Listing(dir, limit, offset, total, path, sort, items):
    // ...
case .Failed(let error):
    // ...
}
```

Listing, as well as other functions have additional parameters. However since we
have to read our code much more often than we write it, it is not necessary to write:
```
disk.listPath(.Disk(""), sort:nil, limit:nil, offset:nil, preview_size:nil, preview_crop:nil, handler:nil)
```
**!!!** All optional parameters have a default value, and so they can be skipped. So, as in the initial examples, write only the parameters you need.

### Creating a folder

```
disk.makeFolderAtPath(.Disk("A"))
```

### What else

I suggest you have a look at the source, or cmd-click on the ```import YandexDiskKit```

---
- ```listPath``` - List metainfo for file or folder.
- ```lastUploaded``` - List latest uploaded files.
- ```listPublicResources``` - List metainfo for public file or folder.
- ```listPublic``` - List metainfo for public file or folder.
- ```listFileResources``` - List metainfo for files. (flat listing)

---
- ```copyPath``` - Copy file or folder.
- ```movePath``` - Move file or folder.
- ```deletePath``` - Delete file or folder.

---
- ```emptyTrash``` - Empties the trash.
- ```restorePath``` - Restores resource from trash.

---
- ```publishPath``` - Publish a resource.
- ```unpublishPath``` - Closing access to a resource.
- ```savePublicToDisk``` - Downloads a public resource to Yandex Disk.
- ```downloadPublic``` - Downloads a public resource.

---
- ```makeFolderAtPath``` - Make Folder.
- ```uploadURL``` - Upload file from local disk or from web to Yandex Disk..
- ```downloadPath``` - Downloads a resource from Yandex Disk.

---
- ```setCustomProperty```
- ```removeCustomProperty```
- ```patchCustomProperties```

---
- ```metainfo``` - Recieves meta info about the disk.

---
- ```apiVersion```
- ```apiVersionImplemented```

## Known limitations

* Requires at least Xcode 6.3 beta with swift 1.2
* The interface heavily depends on swift only features, so the framework is not useable from Obj-C. 
* The ```fields``` parameter is not implemented.
* The documentation is incomplete.

## License

* This SDK is under the [Simplified BSD License][SIMPLEBSDLICENSE] see the LICENSE file for the exact terms.
* The [terms of use][APITERMS] for the Yandex.Disk API can be found at http://legal.yandex.ru/disk_api/


[APITERMS]: http://legal.yandex.ru/disk_api/
[LICENSE]: http://legal.yandex.ru/sdk_agreement
[SIMPLEBSDLICENSE]: http://opensource.org/licenses/BSD-2-Clause
[DISKAPI]: https://tech.yandex.ru/disk/ "Yandex Disk API page"
[AUTHAPI]: https://tech.yandex.ru/oauth/ "Yandex OAuth 2 API page"
[REGISTER]: https://oauth.yandex.ru/client/new "Yandex OAuth app registration page"