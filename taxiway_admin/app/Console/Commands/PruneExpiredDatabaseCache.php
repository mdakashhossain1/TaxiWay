<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

/** The 'database' cache store only deletes an expired row lazily, on the next read of that key — this vacuums the rest. */
class PruneExpiredDatabaseCache extends Command
{
    protected $signature = 'cache:prune-expired-database';

    protected $description = 'Delete expired rows from the database cache table';

    public function handle(): int
    {
        if (config('cache.default') !== 'database') {
            return self::SUCCESS;
        }

        $table = config('cache.stores.database.table', 'cache');
        $deleted = DB::table($table)->where('expiration', '<=', time())->delete();

        $this->info("Pruned {$deleted} expired cache row(s).");

        return self::SUCCESS;
    }
}
