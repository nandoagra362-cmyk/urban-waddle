ALTER TABLE `invoices` ADD `resolution_status` text DEFAULT 'pending' NOT NULL;--> statement-breakpoint
ALTER TABLE `invoices` ADD `resolution_note` text;--> statement-breakpoint
ALTER TABLE `invoices` ADD `resolution_by` text;--> statement-breakpoint
ALTER TABLE `invoices` ADD `resolution_updated_at` text;