DROP TABLE  IF EXISTS user_activity;
-- create user_activity table.
CREATE TABLE `user_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL DEFAULT 'admin',
  `messages` text,
  `user_action` varchar(45) DEFAULT NULL,
  `createddate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `table_type` varchar(45) DEFAULT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- trigger for product_item table
-- drop all trigger 
DROP TRIGGER IF EXISTS product_item__ai;
DROP TRIGGER IF EXISTS product_item__au;
DROP TRIGGER IF EXISTS product_item__bd;

DELIMITER $$
-- trigger for insert
CREATE TRIGGER product_item__ai AFTER INSERT ON product_item FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat('Product Item Nr. ',NEW.product_item_no,' has been created'),'created', NOW(),'master_data'
    FROM product_item AS d WHERE d.product_item_no =NEW.product_item_no;
END$$

-- trigger for update
CREATE TRIGGER product_item__au AFTER UPDATE ON product_item FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat('Product Item Nr. ',NEW.product_item_no,' has been edited'),'edited', NOW(),'master_data'
    FROM product_item AS d WHERE d.product_item_no =NEW.product_item_no;
END$$
DELIMITER ;


-- trigger for mistake_dictionary table
-- drop all trigger 
DROP TRIGGER IF EXISTS mistake_dictionary__ai;
DROP TRIGGER IF EXISTS mistake_dictionary__au;
DROP TRIGGER IF EXISTS mistake_dictionary__bd;

DELIMITER $$
-- trigger for insert
CREATE TRIGGER mistake_dictionary__ai AFTER INSERT ON mistake_dictionary FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat('Mistake Code ',NEW.mistake_code,' has been created'),'created', NOW(),'master_data'
    FROM mistake_dictionary AS d WHERE d.mistake_code =NEW.mistake_code;
END$$

-- trigger for update
CREATE TRIGGER mistake_dictionary__au AFTER UPDATE ON mistake_dictionary FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat('Mistake Code ',NEW.mistake_code,' has been edited'),'edited', NOW(),'master_data'
    FROM mistake_dictionary AS d WHERE d.mistake_code =NEW.mistake_code;
END$$
DELIMITER ;


-- trigger for company table
-- drop all trigger 
DROP TRIGGER IF EXISTS company__ai;
DROP TRIGGER IF EXISTS company__au;
DROP TRIGGER IF EXISTS company__bd;

DELIMITER $$
-- trigger for insert
CREATE TRIGGER company__ai AFTER INSERT ON company FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat(if(NEW.company_kind = 3,'Customer Nr. ','Supplier Nr. ') ,NEW.gildemeisterid,' has been created'),'created', NOW(),'master_data'
    FROM company AS d WHERE d.companyid =NEW.companyid;
END$$

-- trigger for update
CREATE TRIGGER company__au AFTER UPDATE ON company FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat(if(NEW.company_kind = 3,'Customer Nr. ','Supplier Nr. ') ,NEW.gildemeisterid,' has been edited'),'edited', NOW(),'master_data'
    FROM company AS d WHERE d.companyid =NEW.companyid;
END$$
DELIMITER ;


-- trigger for purchase_order table
-- drop all trigger 
DROP TRIGGER IF EXISTS purchase_order__ai;
DROP TRIGGER IF EXISTS purchase_order__au;
DROP TRIGGER IF EXISTS purchase_order__bd;

DELIMITER $$
-- trigger for insert
CREATE TRIGGER purchase_order__ai AFTER INSERT ON purchase_order FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat('Purchase Order Nr. ',NEW.order_no,' has been created'),'created', NOW(),'purchase_order'
    FROM purchase_order AS d WHERE d.orderid =NEW.orderid;
END$$

-- trigger for update
CREATE TRIGGER purchase_order__au AFTER UPDATE ON purchase_order FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat('Purchase Order Nr. ',NEW.order_no,' has been edited'),'edited', NOW(),'purchase_order'
    FROM purchase_order AS d WHERE d.orderid =NEW.orderid;
END$$
DELIMITER ;


-- trigger for order_position table
-- drop all trigger 
DROP TRIGGER IF EXISTS order_position__ai;
DROP TRIGGER IF EXISTS order_position__au;
DROP TRIGGER IF EXISTS order_position__bd;

DELIMITER $$
-- trigger for insert
CREATE TRIGGER order_position__ai AFTER INSERT ON order_position FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,NEW.updateby,concat('Purchase Order Nr. ',po.order_no,' has been created'),'created', NOW(),'purchase_order'
    FROM purchase_order AS po WHERE po.orderid =NEW.orderid;
END$$

-- trigger for update
CREATE TRIGGER order_position__au AFTER UPDATE ON order_position FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,NEW.updateby,concat('Purchase Order Nr. ',po.order_no,' has been edited'),'edited', NOW(),'purchase_order'
    FROM purchase_order AS po WHERE po.orderid =NEW.orderid;
END$$

-- trigger for delete
CREATE TRIGGER order_position__bd BEFORE DELETE ON order_position FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,d.updateby,concat('Purchase Order Nr. ',po.order_no,' has been edited'),'edited', NOW(),'purchase_order'
    FROM purchase_order AS po WHERE po.orderid =OLD.orderid;
END$$
DELIMITER ;


-- trigger for ab table
-- drop all trigger 
DROP TRIGGER IF EXISTS ab__ai;
DROP TRIGGER IF EXISTS ab__au;
DROP TRIGGER IF EXISTS ab__bd;

DELIMITER $$
-- trigger for insert
CREATE TRIGGER ab__ai AFTER INSERT ON ab FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,NEW.updateby,concat('Purchase Order Nr. ',po.order_no,' has been edited'),'edited', NOW(),'purchase_order'
    from purchase_order po 
    inner join order_position op on po.orderid= op.orderid
    inner join ab on ab.positionid = op.positionid and ab.abid = NEW.abid;
END$$

-- trigger for update
CREATE TRIGGER ab__au AFTER UPDATE ON ab FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,NEW.updateby,concat('Purchase Order Nr. ',po.order_no,' has been edited'),'edited', NOW(),'purchase_order'
    from purchase_order po 
    inner join order_position op on po.orderid= op.orderid
    inner join ab on ab.positionid = op.positionid and ab.abid = NEW.abid;
END$$

-- trigger for delete
CREATE TRIGGER ab__bd BEFORE DELETE ON ab FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,OLD.updateby,concat('Purchase Order Nr. ',po.order_no,' has been edited'),'edited', NOW(),'purchase_order'
    from purchase_order po 
    inner join order_position op on po.orderid= op.orderid
    inner join ab on ab.positionid = op.positionid and ab.abid = OLD.abid;
END$$
DELIMITER ;


-- trigger for inspection_report table
-- drop all trigger 
DROP TRIGGER IF EXISTS inspection_report__ai;
DROP TRIGGER IF EXISTS inspection_report__au;
DROP TRIGGER IF EXISTS inspection_report__bd;

DELIMITER $$
-- trigger for insert
CREATE TRIGGER inspection_report__ai AFTER INSERT ON inspection_report FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,NEW.updateby,concat('Inspection Report Nr. ',NEW.inspection_no,' has been created'),'created', NOW(),'inspection_report'
    FROM inspection_report AS d WHERE d.inspectionid =NEW.inspectionid;

    INSERT INTO user_activity SELECT NULL,NEW.updateby,concat('Purchase Order Nr. ',po.order_no,' has been inspected'),'inspected', NOW(),'inspection_report'
    from purchase_order po 
    inner join order_position op on po.orderid= op.orderid
    inner join ab on ab.positionid = op.positionid and ab.abid = NEW.abid;
END$$

-- trigger for update
CREATE TRIGGER inspection_report__au AFTER UPDATE ON inspection_report FOR EACH ROW
BEGIN
    INSERT INTO user_activity SELECT NULL,NEW.updateby,concat('Inspection Report Nr. ',NEW.inspection_no,' has been edited'),'edited', NOW(),'inspection_report'
    FROM inspection_report AS d WHERE d.inspectionid =NEW.inspectionid;

    INSERT INTO user_activity 
    SELECT NULL,NEW.updateby,concat('Purchase Order Nr. ',po.order_no,' ',op.position_no,' has not-full ordered quantity inspected'),'inspected', NOW(),'inspection_report' 
    from purchase_order po 
    inner join order_position op on po.orderid= op.orderid
    inner join ab on ab.positionid = op.positionid and ab.abid = NEW.abid
    having (select op.ordered_quantity) > 
    (select sum(ir.quantity_accepted) from inspection_report ir inner join ab on ir.abid = ab.abid
    inner join order_position op2 on op2.positionid = ab.positionid and op2.positionid = (select op.positionid));
END$$

DELIMITER ;