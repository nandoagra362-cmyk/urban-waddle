CREATE TABLE `billing_settings` (
	`id` text PRIMARY KEY NOT NULL,
	`provider` text NOT NULL,
	`updated_at` text NOT NULL
);
--> statement-breakpoint
ALTER TABLE `stores` ADD `blocked_at` text;