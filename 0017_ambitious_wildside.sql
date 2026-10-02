DROP INDEX `native_accounts_store`;--> statement-breakpoint
ALTER TABLE `native_accounts` ADD `role` text DEFAULT 'manager' NOT NULL;--> statement-breakpoint
CREATE INDEX `native_accounts_store` ON `native_accounts` (`store_id`);