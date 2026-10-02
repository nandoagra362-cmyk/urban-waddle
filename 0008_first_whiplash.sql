CREATE TABLE `mp_live_payments` (
	`payment_id` text PRIMARY KEY NOT NULL,
	`subscription_id` text NOT NULL,
	`store_id` text NOT NULL,
	`paid_at` text NOT NULL,
	`amount_cents` integer NOT NULL,
	FOREIGN KEY (`subscription_id`) REFERENCES `mp_live_subscriptions`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`store_id`) REFERENCES `stores`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `mp_live_payments_store` ON `mp_live_payments` (`store_id`);