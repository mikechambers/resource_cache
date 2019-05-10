
import "dart:io";
import "dart:convert";
import "dart:async";
import 'package:crypto/crypto.dart';

///Class that manages and retains a local cache of remote files based on the original
///remote URI for the resources.
class ResourceCache {


  ///Name of the cache directory that will be created within the Directory
  ///specified in the constructor.
  final String CACHE_DIR_NAME = "_cache";
  Directory _cacheBaseDirectory;

  ///Constructor that the base directory that the cache directory
  ///will be created in.
  ResourceCache(Directory cacheDirectory) {
    _cacheBaseDirectory = cacheDirectory;
  }

  Future<File> _getItemFile(String key) async {
    Directory d = await _getCacheDirectory();
    File f = new File("${d.path}/$key");
    return f;
  }

  Future<Directory> _getCacheDirectory() async {
    var dir = new Directory("${_cacheBaseDirectory.path}/$CACHE_DIR_NAME");

    if(await dir.exists()) {
      return dir;
    } else {
      dir = await dir.create(recursive: true);
      return dir;
    }
  }

  ///Clears the cache and deletes the cache directory. Note, the directory will be automatically
  ///recreated when calling retrieve().
  void clear() async {
    Directory d = await _getCacheDirectory();
    await d.delete(recursive: true);
  }

  String _generateKeyHash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  ///Takes a URL for a remote HTTP resource, and returns a URI pointing to the resource.
  ///If the resource does not exist in the cache, it will be downloaded and cached, and a
  ///file uri will be returned pointing to it.
  ///If the resource already exists in the cache, a URI pointing to it will be returned.
  ///If any errors occur while retrieving the remote resource, or caching it, a URI pointing
  ///to the original URL will be returned.
  Future<Uri> retrieve(String url) async {
    String key = _generateKeyHash(url);
    File file = await _getItemFile(key);

    Uri uri;
    if(await file.exists()) {
      //download file
      uri = file.uri;
    } else {

      uri = Uri.parse(url);
      try {
        HttpClient client = new HttpClient();
        var request = await client.getUrl(uri);
        var response = await request.close();

        //todo: need to test this with redirects and other status codes
        if(response.statusCode == 200) {
          var bytes = List<int>();
          await response.forEach((d) => bytes.addAll(d));
          await file.writeAsBytes(bytes);

          uri = file.uri;
        }

      } catch(error) {
        //if an error occurs, we just catch it, and the original URI will be returned.
        print(error);
      }
    }

    return uri;
  }
}
