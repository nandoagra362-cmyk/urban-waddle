CREATE TABLE `purchasing_changes` (
	`id` text PRIMARY KEY NOT NULL,
	`store_id` text NOT NULL,
	`invoice_id` text NOT NULL,
	`menu` text NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `purchasing_changes_store_menu_date` ON `purchasing_changes` (`store_id`,`menu`,`created_at`);