CREATE TABLE asset (
    id TEXT NOT NULL PRIMARY KEY,
    remote_url TEXT NOT NULL,
    source_id TEXT NOT NULL REFERENCES asset_source(id)
) STRICT;

CREATE TABLE asset_source (
    id TEXT NOT NULL PRIMARY KEY,
    expires_time INTEGER,
    etag TEXT,
    hash TEXT NOT NULL,
    size INTEGER NOT NULL,
    data_internal BLOB,
    data_external TEXT,
    CHECK (data_internal IS NOT NULL OR data_external IS NOT NULL)
) STRICT;

CREATE TABLE asset_version (
    id TEXT NOT NULL PRIMARY KEY,
    source_id TEXT NOT NULL REFERENCES asset_source(id),
    etag TEXT NOT NULL,
    kind TEXT NOT NULL CHECK (kind IN ('text', 'image')),
    data_kind TEXT NOT NULL CHECK (kind IN ('html', 'css', 'js', 'svg', 'raster')),
    last_used INTEGER NOT NULL REFERENCES epoch_history(epoch),
    size INTEGER NOT NULL,
    data_internal BLOB,
    data_external TEXT,
    CHECK (data_internal IS NOT NULL OR data_external IS NOT NULL)
) STRICT;

CREATE TABLE asset_meta_sk_text (
    version_id TEXT NOT NULL PRIMARY KEY REFERENCES asset_version(id),
    compression TEXT NOT NULL CHECK (compression IN ('none', 'gzip', "zstd"))
) STRICT;

CREATE TABLE asset_meta_sk_image (
    version_id TEXT NOT NULL PRIMARY KEY REFERENCES asset_version(id),
    format TEXT NOT NULL CHECK (format IN ('png', 'jpeg', 'webp', 'avif')),
    width INTEGER NOT NULL,
    height INTEGER NOT NULL
) STRICT;

CREATE TABLE asset_blurhash (
    id TEXT NOT NULL PRIMARY KEY,
    source_id TEXT NOT NULL REFERENCES asset_source(id),
) STRICT;


CREATE TABLE epoch_history (
    epoch INTEGER NOT NULL PRIMARY KEY,
    start_time INTEGER NOT NULL
) STRICT;
