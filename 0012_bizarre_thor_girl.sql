CREATE TABLE `deleted_invoices` (
	`id` text PRIMARY KEY NOT NULL,
	`store_id` text NOT NULL,
	`number` text NOT NULL,
	`supplier` text NOT NULL,
	`checker_name` text NOT NULL,
	`original_created_at` text NOT NULL,
	`completed_at` text,
	`item_count` integer NOT NULL,
	`deleted_by` text NOT NULL,
	`deleted_by_email` text NOT NULL,
	`reason` text NOT NULL,
	`deleted_at` text NOT NULL,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `deleted_invoices_store_date` ON `deleted_invoices` (`store_id`,`deleted_at`);