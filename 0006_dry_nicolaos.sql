CREATE TABLE `mp_test_config` (
	`id` text PRIMARY KEY NOT NULL,
	`seller_id` text NOT NULL,
	`token_cipher` text NOT NULL,
	`webhook_cipher` text DEFAULT '' NOT NULL,
	`updated_at` text NOT NULL
);
