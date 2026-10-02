ALTER TABLE `stores` ADD `access_status` text DEFAULT 'approved' NOT NULL;--> statement-breakpoint
ALTER TABLE `stores` ADD `access_reviewed_at` text;--> statement-breakpoint
ALTER TABLE `stores` ADD `access_reviewed_by` text;