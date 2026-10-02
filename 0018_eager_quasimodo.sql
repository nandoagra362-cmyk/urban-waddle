CREATE TABLE `purchasing_messages` (
	`id` text PRIMARY KEY NOT NULL,
	`invoice_id` text NOT NULL,
	`store_id` text NOT NULL,
	`sender_role` text NOT NULL,
	`sender_email` text NOT NULL,
	`body` text NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`invoice_id`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `purchasing_messages_invoice_date` ON `purchasing_messages` (`invoice_id`,`created_at`);--> statement-breakpoint
CREATE INDEX `purchasing_messages_store_date` ON `purchasing_messages` (`store_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `purchasing_reads` (
	`viewer_key` text NOT NULL,
	`seen_at` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `purchasing_reads_viewer` ON `purchasing_reads` (`viewer_key`);--> statement-breakpoint
ALTER TABLE `invoices` ADD `xml_key` text;--> statement-breakpoint
ALTER TABLE `invoices` ADD `purchasing_entry` integer;--> statement-breakpoint
ALTER TABLE `invoices` ADD `entry_updated_at` text;