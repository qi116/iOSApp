-- farmers_database.users definition

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email_address` varchar(255) NOT NULL,
  `salted_password` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `profile_picture` blob DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `user_type` enum('vendor','customer') NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- farmers_database.messages definition

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_user_id` int(11) NOT NULL,
  `recipient_user_id` int(11) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `time_sent` datetime DEFAULT NULL,
  PRIMARY KEY (`message_id`),
  KEY `messages_FK` (`sender_user_id`),
  KEY `messages_FK_1` (`recipient_user_id`),
  CONSTRAINT `messages_FK` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `messages_FK_1` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- farmers_database.sessions definition

CREATE TABLE `sessions` (
  `session_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `session_code` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `sessions_FK` (`user_id`),
  CONSTRAINT `sessions_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- farmers_database.vendors definition

CREATE TABLE `vendors` (
  `vendor_id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_user_id` int(11) NOT NULL,
  `background_picture` blob DEFAULT NULL,
  `description` text DEFAULT NULL,
  `longitude` decimal(9,6) DEFAULT NULL,
  `latitude` decimal(9,6) DEFAULT NULL,
  PRIMARY KEY (`vendor_id`),
  KEY `vendors_FK` (`owner_user_id`),
  CONSTRAINT `vendors_FK` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- farmers_database.goods definition

CREATE TABLE `goods` (
  `good_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` text DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `picture` blob DEFAULT NULL,
  `good_type` int(11) NOT NULL,
  PRIMARY KEY (`good_id`),
  KEY `goods_FK` (`vendor_id`),
  CONSTRAINT `goods_FK` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- farmers_database.reviews definition

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL AUTO_INCREMENT,
  `good_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `stars` int(11) DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `reviews_FK` (`good_id`),
  KEY `reviews_FK_1` (`user_id`),
  CONSTRAINT `reviews_FK` FOREIGN KEY (`good_id`) REFERENCES `goods` (`good_id`),
  CONSTRAINT `reviews_FK_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- farmers_database.favorites definition

CREATE TABLE `favorites` (
  `favorite_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `good_id` int(11) NOT NULL,
  PRIMARY KEY (`favorite_id`),
  KEY `favorites_FK` (`user_id`),
  KEY `favorites_FK_1` (`good_id`),
  CONSTRAINT `favorites_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `favorites_FK_1` FOREIGN KEY (`good_id`) REFERENCES `goods` (`good_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;