## Dumb Key Value

Dumb Key Value is a Key Value Store Specification, so that I can learn basic operations
in multiple languages by implementing the same semantics and functionality.

# Key and Value Spec

### Key

Keys must conform to the base62 character set, meaning:

```
ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
0123456789
```

This is for simplicity and legibility in the URL.

### Value

Values can be provided in any type, but will be converted to strings for storage and retrieval.
It is up to the consumer to then convert/coerce/transform/parse the returned string back into
the user preferred format.

# API Spec

If a given route does not have a specified implementation of a given method besides `OPTIONS`,
one can assume that usage of the method will result in an 405 Method Not Allowed error.

Every route when called with the `OPTIONS` method will respond with the allowed methods

All failed calls produce no side effects and do not count as mutating writes.

### `{base}/capabilities`

### GET

Return the capabilities of the current implementation, as well as which extensions are
available, enabled, or disabled

### `{base}/keys`

#### GET

Return all keys in the store.
Keys are returned as a JSON list of strings:
`['key1','key2']`

#### POST

Create a new key-value pair, or multiple key-value pairs.

Fails if any key provided already exists

Post bodies will be in json format and require the header `Content-Type: application/json`.

Single key add:

```
{ 'key': 'value'}
```

multi key add:

```
{ 'key1': 'value1','key2': 'value2'}
```

#### PATCH

Alias for PUT behavior

#### PUT

Bulk update existing key value pairs.
Requires all keys provided to exist, will 404 if one or more are not present.

Put bodies will be in json format and require the header `Content-Type: application/json`.
Single key update:

```
{ 'key': 'value'}
```

multi key update:

```
{ 'key1': 'value1', 'key2': 'value2'}
```

#### DELETE

Remove all keys from the key value store

### `{base}/keys/{key}`

`key` refers to value within `{key}`

#### GET

Return value for `key`:

```
{'key': 'value'}
```

#### PATCH

Alias for PUT behavior

#### PUT

Update value for `key`
anything in body of HTTP request is set as value for key

#### DELETE

deletes `key` and its value from store.

# Storage Spec

Key-Value pairs are persisted in a single file on disk as a flat JSON object,
but are served by an in memory key-value map.

This file is written to on every mutating write.
This file is not watched for changes. It is only read from on startup of the KV store.

# Undefined Behavior

By Default if two sequential mutating calls to the same key are made:

- No guarantee is made that the final value of the KV store will be the value provided by the second call. For example, say call 1 provides a very large value and call 2 provides a small value, should call 2 complete before call 1 is able to finish loading the HTTP request, then call 1 would write to the in memory representation after call 2's completion.

# Extensions

All extensions must be compatible with each other, and must be able to be turned on or off without breaking guarantees of other extensions.

### Alternate Key Character Sets Extension

By default, we support only base62. It is possible that users may want to use other values in their key names, so we should allow the implementation of alternate character sets, such as base58, 32, 36, and more.

A single character set should be selected at start time and used for all requests therein.

#### on-the-fly character set selection sub-extension

Allow each call to choose it's character set via an optional query param.

#### character set collision configuration extension

by default all character sets use the same storage engine, so if I get a base62 set key 'hello' and base 58 set 'heLLo', I should be able to control whether or not 'heLLo' is normalized and considered a collision with 'hello'

#### character set namespacing configuration extension

by default all character sets use the same storage engine, so if I get a base62 set key 'heLLo' and base 58 set 'heLLo', I should be able to specify whether these collide or if because they're in different character sets they live in different storage engines.

#### Encoding sub-extension

allow for keys to be provided encoded in some way, i.e. base64, base64url, base32, etc, such that the actual key value will be the decoded value provided.
encoding should be selectable on the fly via an optional query parameter.

### `{base}/keys` Post/Put Body extension:

instead of just json, implement the ability for `{base}/keys` Post and Put requests to handle one of three formats, based on their content type:

- Content-Type: `application/x-www-form-urlencoded`:
  ```
  key1=value1&key2=value2
  ```
- Content-Type: `multipart/form-data;boundary="user-chosen-boundary"`:

  ```
  --user-chosen-boundary
  Content-Disposition: form-data; name="key1"

  value1
  --user-chosen-boundary
  Content-Disposition: form-data; name="key2"

  value2
  ```

- Content-Type: `application/json`:
  ```
  { 'key1': 'value1','key2': 'value2'}
  ```

### File Based Storage Engine

Instead of serving values from an in memory map, we store all keys and values in files in the file system. When a key is created, we create a file for that key and the files contents are the value. A 200 response means that file contents have been written and synced with the file system such that in case of power failure, file contents should be preserved.

#### Cache sub-extension

To speed up reads, implement a configurable LRU cache to serve popular KV pairs.
required confguration values:

- maximumm number of keys to keep in cache
- update cache on write or invalidate cache on write

optional configuration values:

- max cache size in kilobytes
- time to live for cache values

### JSON KV store

Instead of storing contents as Strings, Instead only accept valid JSON values and return them as such.

```
POST -> {
  'dog': {
    'name': 'Stephen',
    'breed': 'Poodle'
  }
}

GET without extension -> {
  'dog': '{\'name\':\'Stephen\',\'breed\':\'Poodle\'}'
}

GET with extension: -> {
  'dog': {
    'name': 'Stephen',
    'breed': 'Poodle'
  }
}
```

### Call Order Consistency

Implement a way to guarantee that should two mutating calls come in for the same key, the most recent received call will always be the final result of the given
