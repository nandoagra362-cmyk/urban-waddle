CREATE TABLE `invoice_import_keys` (
	`store_id` text NOT NULL,
	`access_key` text NOT NULL,
	`invoice_id` text NOT NULL,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `invoice_import_keys_store_key` ON `invoice_import_keys` (`store_id`,`access_key`);
--> statement-breakpoint
INSERT OR IGNORE INTO `invoice_import_keys` (`store_id`,`access_key`,`invoice_id`) SELECT `store_id`,`access_key`,`id` FROM `invoices` WHERE length(`access_key`)=44 ORDER BY `created_at`;
