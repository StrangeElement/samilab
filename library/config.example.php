<?php
declare(strict_types=1);

/**
 * samilab.io — Scientific Library Configuration Template
 *
 * Copy this file to `config.local.php` (ignored by Git) and set your local
 * or production credentials. Never commit `config.local.php` to version control.
 */

return [
    'env' => 'development', // 'development' (enables test data generator tab) or 'production'

    'db' => [
        'host'     => '127.0.0.1',
        'port'     => 3306,
        'dbname'   => 'samilab_library_test',
        'user'     => 'sami_local',
        'password' => 'sami_local_dev_2026',
        'charset'  => 'utf8mb4',
    ],

    'security' => [
        // SHA-256 hash of the single Admin console password
        'admin_password_hash' => 'REPLACE_WITH_SHA256_HASH',

        // SHA-256 hashes of the 3 Bearer API keys
        'api_keys_sha256' => [
            'read'   => 'REPLACE_WITH_READ_KEY_SHA256_HASH',
            'crud'   => 'REPLACE_WITH_CRUD_KEY_SHA256_HASH',
            'schema' => 'REPLACE_WITH_SCHEMA_KEY_SHA256_HASH',
        ],
    ],
];
