CREATE TABLE `invoice_items` (
	`id` text PRIMARY KEY NOT NULL,
	`invoice_id` text NOT NULL,
	`description` text NOT NULL,
	`code` text NOT NULL,
	`trib_code` text NOT NULL,
	`sku` text NOT NULL,
	`unit` text NOT NULL,
	`expected` real NOT NULL,
	`counted` integer DEFAULT 0 NOT NULL,
	FOREIGN KEY (`invoice_id`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `invoice_items_invoice` ON `invoice_items` (`invoice_id`);--> statement-breakpoint
CREATE TABLE `invoices` (
	`id` text PRIMARY KEY NOT NULL,
	`store_id` text NOT NULL,
	`number` text NOT NULL,
	`supplier` text NOT NULL,
	`access_key` text,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `invoices_store_created` ON `invoices` (`store_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `stores` (
	`id` text PRIMARY KEY NOT NULL,
	`owner_id` text NOT NULL,
	`name` text NOT NULL,
	`created_at` text NOT NULL,
	`plan` text DEFAULT 'piloto' NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `stores_owner_unique` ON `stores` (`owner_id`);--> statement-breakpoint
CREATE TABLE `unexpected_scans` (
	`id` text PRIMARY KEY NOT NULL,
	`invoice_id` text NOT NULL,
	`code` text NOT NULL,
	`counted` integer NOT NULL,
	FOREIGN KEY (`invoice_id`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `unexpected_invoice_code` ON `unexpected_scans` (`invoice_id`,`code`);