ALTER TABLE `mp_live_config` ADD `price_cents` integer DEFAULT 4999 NOT NULL;--> statement-breakpoint
ALTER TABLE `mp_live_subscriptions` ADD `price_cents` integer DEFAULT 4999 NOT NULL;