CREATE TABLE `mp_live_config` (
	`id` text PRIMARY KEY NOT NULL,
	`token_cipher` text NOT NULL,
	`webhook_cipher` text NOT NULL,
	`enabled` integer DEFAULT 0 NOT NULL,
	`updated_at` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `mp_live_subscriptions` (
	`id` text PRIMARY KEY NOT NULL,
	`store_id` text NOT NULL,
	`provider_id` text NOT NULL,
	`status` text NOT NULL,
	`checkout_url` text NOT NULL,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `mp_live_subscriptions_provider` ON `mp_live_subscriptions` (`provider_id`);--> statement-breakpoint
CREATE INDEX `mp_live_subscriptions_store` ON `mp_live_subscriptions` (`store_id`);