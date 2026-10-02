CREATE TABLE `conference_locks` (
	`invoice_id` text PRIMARY KEY NOT NULL,
	`store_id` text NOT NULL,
	`holder_token` text NOT NULL,
	`holder_name` text NOT NULL,
	`expires_at` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`invoice_id`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `conference_locks_store` ON `conference_locks` (`store_id`);