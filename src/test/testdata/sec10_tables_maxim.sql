-- DDL (Table) Generation for Sec
-- Target Database is mySql + Ruby on Rails

--                                '*** Start Custom Code database connect
--                                '*** End Custom Code

-- Table secenhancements
  --   These are bug enhancements
--  ' > CREATING - secenhancements ...'
DROP TABLE IF EXISTS secenhancements ;
CREATE TABLE secenhancements (
  id             INT AUTO_INCREMENT Not null PRIMARY KEY 
  , created_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_user         varchar(30) not null
  , title Varchar(150) 
  , notes Varchar() 
  , create_date Datetime 
  , created_user Varchar(30) 
  , signoff_date Datetime 
  , is_urgent Smallint 
  , priority Varchar(1) 
  ,  web_action_id Integer NULL
); 

-- Table secrights
  --   
--  ' > CREATING - secrights ...'
DROP TABLE IF EXISTS secrights ;
CREATE TABLE secrights (
  id             INT AUTO_INCREMENT Not null PRIMARY KEY 
  , created_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_user         varchar(30) not null
  , name Varchar(60) not Null
  , context Varchar(50) 
  ,  role_id Integer NULL
); 

-- Table secroles
  --   
--  ' > CREATING - secroles ...'
DROP TABLE IF EXISTS secroles ;
CREATE TABLE secroles (
  id             INT AUTO_INCREMENT Not null PRIMARY KEY 
  , created_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_user         varchar(30) not null
  , name Varchar(60) not Null
  , security_level INT 
); 

-- Table secusers
  --   
--  ' > CREATING - secusers ...'
DROP TABLE IF EXISTS secusers ;
CREATE TABLE secusers (
  id             INT AUTO_INCREMENT Not null PRIMARY KEY 
  , created_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_user         varchar(30) not null
  , name Varchar(50) not Null
  , network_id Varchar(30) 
  , email_address Varchar(60) not Null
  , phone_number Varchar(30) 
  , password Varchar(40) 
  , last_visit_date Datetime 
  , level INT 
  , preferences Varchar(300) 
  ,  workgroup_id Integer NULL
); 

-- Table secuser_roles
  --   
--  ' > CREATING - secuser_roles ...'
DROP TABLE IF EXISTS secuser_roles ;
CREATE TABLE secuser_roles (
  id             INT AUTO_INCREMENT Not null PRIMARY KEY 
  , created_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_user         varchar(30) not null
  ,  user_id Integer NULL
  ,  role_id Integer NULL
); 

-- Table secweb_actions
  --   This holds the information about each web action
--  ' > CREATING - secweb_actions ...'
DROP TABLE IF EXISTS secweb_actions ;
CREATE TABLE secweb_actions (
  id             INT AUTO_INCREMENT Not null PRIMARY KEY 
  , created_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_user         varchar(30) not null
  , name Varchar(60) not Null
  , title Varchar(30) 
  , introduction Lonttext 
  , footer Lonttext 
  , security_level INT 
  , size INT 
  , action_group Varchar(20) 
  , created_date Datetime not Null
  , started_date Datetime 
  , programmed_date Datetime 
  , signoff_date Datetime 
  , signoff_content_date Datetime 
  , description Varchar(200) 
  , style Varchar(3) 
  , parameters Varchar(250) 
  , week_no INT 
); 

-- Table secworkgroups
  --   
--  ' > CREATING - secworkgroups ...'
DROP TABLE IF EXISTS secworkgroups ;
CREATE TABLE secworkgroups (
  id             INT AUTO_INCREMENT Not null PRIMARY KEY 
  , created_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_on      DATETIME not null DEFAULT CURRENT_TIMESTAMP
  , updated_user         varchar(30) not null
  , name Varchar(60) not Null
); 



/* comment out for now
ALTER TABLE secenhancements ADD CONSTRAINT fk_enhancement_web_action
  FOREIGN KEY fk_web_action(web_action_id)
  references secweb_actions(ID);
ALTER TABLE secrights ADD CONSTRAINT fk_right_role
  FOREIGN KEY fk_role(role_id)
  references secroles(ID);
ALTER TABLE secusers ADD CONSTRAINT fk_user_workgroup
  FOREIGN KEY fk_workgroup(workgroup_id)
  references secworkgroups(ID);
ALTER TABLE secuser_roles ADD CONSTRAINT fk_user_role_user
  FOREIGN KEY fk_user(user_id)
  references secusers(ID);
ALTER TABLE secuser_roles ADD CONSTRAINT fk_user_role_role
  FOREIGN KEY fk_role(role_id)
  references secroles(ID);
*/ 
-- '   > ALTER - add uniqueness for column name to secrights table ...'
ALTER TABLE secrights
ADD
  CONSTRAINT secrights_uq1 UNIQUE NONCLUSTERED (name);
-- '   > ALTER - add uniqueness for column name to secroles table ...'
ALTER TABLE secroles
ADD
  CONSTRAINT secroles_uq1 UNIQUE NONCLUSTERED (name);
-- '   > ALTER - add uniqueness for column emailaddress to secusers table ...'
ALTER TABLE secusers
ADD
  CONSTRAINT secusers_uq1 UNIQUE NONCLUSTERED (email_address);
-- '   > ALTER - add uniqueness for column name to secweb_actions table ...'
ALTER TABLE secweb_actions
ADD
  CONSTRAINT secweb_actions_uq1 UNIQUE NONCLUSTERED (name);
-- '   > ALTER - add uniqueness for column name to secworkgroups table ...'
ALTER TABLE secworkgroups
ADD
  CONSTRAINT secworkgroups_uq1 UNIQUE NONCLUSTERED (name);

-- Table Creation Script Finished

--                                '*** Start Custom Code populatetestdata
--                                '*** End Custom Code


