CREATE TABLE `buyer_stores` (
	`account_id` text NOT NULL,
	`store_id` text NOT NULL,
	`status` text DEFAULT 'pending' NOT NULL,
	`invited_by` text NOT NULL,
	`created_at` text NOT NULL,
	`accepted_at` text,
	FOREIGN KEY (`account_id`) REFERENCES `native_accounts`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `buyer_stores_account_store` ON `buyer_stores` (`account_id`,`store_id`);--> statement-breakpoint
CREATE INDEX `buyer_stores_store` ON `buyer_stores` (`store_id`);
--> statement-breakpoint
INSERT INTO buyer_stores(account_id,store_id,status,invited_by,created_at,accepted_at) SELECT id,store_id,'active',email,created_at,created_at FROM native_accounts WHERE role='buyer';
