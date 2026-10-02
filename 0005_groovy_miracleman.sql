CREATE TABLE `mp_test_subscriptions` (
	`id` text PRIMARY KEY NOT NULL,
	`store_id` text NOT NULL,
	`payer_email` text NOT NULL,
	`provider_id` text NOT NULL,
	`status` text NOT NULL,
	`checkout_url` text NOT NULL,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `mp_test_subscriptions_provider` ON `mp_test_subscriptions` (`provider_id`);--> statement-breakpoint
CREATE INDEX `mp_test_subscriptions_store` ON `mp_test_subscriptions` (`store_id`);