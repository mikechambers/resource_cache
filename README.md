# resource_cache

resource_cache is a Dart library for retrieving, caching and managing remote HTTP resources.

## Usage

```dart
import "dart:io";
import "package:resource_cache/resource_cache.dart";

void main() async {

  //Directory that the cache directory will be created within.
  Directory d = Directory.systemTemp;

  //create the cache, passing in the root directory.
  var cache = ResourceCache(d);

  //Url to retrieve
  var url = "http://mikechambers.com/blog/images/posts/twitchlivefirefox/screenshot.png";

  //This returns a file referencing a cached local copy of the remote resource.
  File f  = await cache.retrieve(url);

  print(f.path);
}
```

## Installation

Add the following to your pubspec.yaml file:

```yaml
resource_cache:
```

and then run

```
pub get
```
