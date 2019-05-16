import "dart:io";
import "package:resource_cache/resource_cache.dart";

void main() async {

  //Directory that the cache directory will be created within.
  Directory d = Directory.systemTemp;

  //create the cache, passing in the root directory.
  var cache = ResourceCache(d);

  //Url to retrieve
  var url = "http://mikechambers.com/blog/images/posts/twitchlivefirefox/screenshot.png";

  //This returns a Uri. It will be a file:/ uri if the file was already cached, or
  //succesfully cached.
  //It the original Uri if there was an error, or the file could not be cached.
  File f = await cache.retrieve(url);

  print(f.path);
  exit(0);
}