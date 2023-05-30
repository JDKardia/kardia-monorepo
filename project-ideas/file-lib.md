# File Library/Archive/Server

I came across a cool tool called hydrus for organizing and accessing hoarded media.
After playing with it for a bit though, I found it had seriously lacking UX,
extensibility, and overall it felt too niche where I wanted breadth and too broad where
i wanted niche.

Not to mention, I have tons of documents and files that don't cleanly fit the 'media'
definition that Hydrus follows.

I realize the creator of hydrus provides his work under the WTFPLS license, but I feel
like a similar but different approach could better utilize community contributions,
while also expanding functionality, stability, performance, etc.

# MVP Goals

- Server and UI are separate
- Server exposes APIs to extend functionality, as much functionality as possible should
  live within plugins. REST? gRPC/Protobuf?
- All file ingestion should be done via plugins or APIs, the server itself strictly manages storage, indexing, and serving of file locations
- Files can be either colocated with the server, on another server, or on object based storage such as s3, r2, minio, etc.
- As wide of filetype support as possible, starting with most common
- minimize storage usage and latency using compression such as zstd or lz4
- configurable hotkeys
- gallery is file agnostic

# Stretch Goals

- Live transcoding into efficient formats for data saving.
- Graceful evolution and migration from personal archives to community archives
- Collections of images as persistent galleries
- clustering of images and videos as ordered singular entity (think clustering of pages for comic book or ordered playlists of videos)
