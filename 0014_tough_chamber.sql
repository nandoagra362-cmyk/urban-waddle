ALTER TABLE `invoices` ADD `has_divergence` integer;--> statement-breakpoint
ALTER TABLE `invoices` ADD `divergence_reason` text;--> statement-breakpoint
ALTER TABLE `invoices` ADD `purchasing_notified` integer;