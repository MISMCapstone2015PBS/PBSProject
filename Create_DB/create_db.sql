/*  
   P R O G R A M / R I G H T S   L E V E L 
          REFERENCE TABLES
*/
create table Category
  (Category_id int,
   Category_code Char(6),
   Category_description Varchar(40),
   Category_isArchived numeric(1) not null,
   CONSTRAINT pk_Category PRIMARY KEY (category_id)
   );

create table FeedDistributor
  (FeedDistributor_id int,
   FeedDistributor_code Char(6),
   FeedDistributor_name Varchar(80),
   FeedDistributor_isArchived numeric(1) not null,
   CONSTRAINT pk_FeedDistributor PRIMARY KEY (FeedDistributor_id)
   );

 create table VChip
  (VChip_id int,
   VChip_code Varchar(10),
   VChip_description Varchar(40),
   VChip_isArchived numeric(1) not null,
   CONSTRAINT pk_VChip PRIMARY KEY (VChip_id),
   CONSTRAINT uc_VChip_code UNIQUE (VChip_code)
   );

 create table Format
  (Format_id int,
   Format_code Varchar(6) not null,
   Format_description Varchar(40) not null,
   Format_isArchived numeric(1) not null,
   CONSTRAINT pk_Format PRIMARY KEY (Format_id)
   );

 create table TiVoKeyword
  (TiVoKeyword_id int,
   TiVoKeyword_description Varchar(40) not null,
   TiVoKeyword_isArchived numeric(1) not null,
   CONSTRAINT pk_TiVoKeyword PRIMARY KEY (TiVoKeyword_id),
   CONSTRAINT uc_TiVoKeyword_description UNIQUE (TiVoKeyword_description)
   );

 create table Keyword
  (Keyword_id int,
   Keyword_description Varchar(40) not null,
   Keyword_isArchived numeric(1) not null,
   CONSTRAINT pk_Keyword PRIMARY KEY (Keyword_id),
   CONSTRAINT uc_Keyword_description UNIQUE (Keyword_description)
   );

 create table Genre
  (Genre_id int,
   Genre_code Char(6),
   Genre_description Varchar(40) not null,
   Genre_isArchived numeric(1) not null,
   CONSTRAINT pk_genre PRIMARY KEY (genre_id)
   );

 create table Talent
  (Talent_id int,
   Talent_Name Varchar(80),
   Talent_NameLast Varchar(40),
   Talent_NameFirst Varchar(40),
   Talent_URL	Varchar(252),
   Talent_isArchived numeric(1) not null,
   CONSTRAINT pk_Talent_id PRIMARY KEY (Talent_id)
   );

 create table TalentRole
  (TalentRole_id int,
   TalentRole_code Char(3),
   TalentRole_description Varchar(40),
   TalentRole_isArchived numeric(1) not null,
   CONSTRAINT pk_TalentRole PRIMARY KEY (TalentRole_id)
   );

 create table ContactType
 (ContactType_Id int,
  ContactType_Code Varchar(80) not null,
   CONSTRAINT pk_contactType PRIMARY KEY (ContactType_Id)
  );

 create table Company
 (Company_Id int,
  Company_LongName Varchar(80) not null,
  Company_ShortName Varchar(40),
  Company_IsSupplier numeric(1),
  Company_IsLicensor numeric(1),
  Company_IsAgency numeric(1),
  Company_IsAdvertiser numeric(1),
  Company_IsFunder numeric(1),
  Company_IsProducer numeric(1),
  Company_IsPresenter numeric(1),
  Company_IsArchived numeric(1) not null,
   CONSTRAINT pk_company PRIMARY KEY (Company_Id)
  );

 create table Rights_Group
 (Group_Id int,
  Group_Description  Varchar(80) not null,
  CONSTRAINT pk_Rights_Group PRIMARY KEY (Group_Id)
  );

 create table Channel
  (Channel_id int,
   Channel_Group_Id int not null,
   Channel_Type Char(3) not null,
   Channel_Description Varchar(20) not null,
   CONSTRAINT pk_Channel PRIMARY KEY (Channel_id),
   CONSTRAINT uc_Channel_Description UNIQUE (Channel_Description),
   CONSTRAINT fk_Channel_Group_Id foreign key (Channel_Group_Id) references Rights_Group (Group_Id)
   );

 create table Rights_Rule
 (Rule_Id int,
  Rule_Description Varchar(40),
  Rule_RightType Char(1),
  Rule_AirsPerRelease int,
  CONSTRAINT pk_Rights_Rule PRIMARY KEY (Rule_Id),
  CONSTRAINT uc_Rule_Description UNIQUE (Rule_Description)
  );

 create table SegmentCategory
  (SegmentCategory_Id int,
   SegmentCategory_code Varchar(6) not null,
   SegmentCategory_description Varchar(40) not null,
   SegmentCategory_isArchived numeric(1) not null,
   CONSTRAINT pk_SegmentCategory PRIMARY KEY (SegmentCategory_Id)
   );   

/*        
   P R O G R A M / R I G H T S   L E V E L
              MAIN TABLES    
*/
 
 create table Asset
 (Asset_Id int,
  Asset_Vchip_Id int,
  Asset_Category_Id int,
  Asset_FeedDistributor_Id int,
  Asset_Title Varchar(80) not null,
  Asset_EpisodeTitle Varchar(80),
  Asset_Duration int,
  Asset_ListingTitle Varchar(80),
  Asset_Synopsis Varchar(268) /*blob*/,
  Asset_URL Varchar(252),
  Asset_Code Varchar(20),
  Asset_EPGTitle Varchar(80),
  Asset_EPGText Varchar(268) /*blob*/,
  Asset_EpisodeSeason varchar(20),
  Asset_EpisodeNumber varchar(20),
  Asset_Type char(3) not null,
  Asset_IsArchived numeric(1) not null,
  Asset_AltListingTitle Varchar(80),
  Asset_AltSynopsis Varchar(268) /*blob*/,
  Asset_AltEPGTitle Varchar(80),
  Asset_AltEPGText Varchar(268) /*blob*/,
  CONSTRAINT pk_Asset PRIMARY KEY (Asset_Id),
  CONSTRAINT fk_A_Asset_Vchip_Id foreign key (Asset_Vchip_Id) references VChip (Vchip_Id),
  CONSTRAINT fk_A_Asset_Category_Id foreign key (Asset_Category_Id) references Category (Category_Id),
  CONSTRAINT fk_A_Asset_FeedDistributor_Id foreign key (Asset_FeedDistributor_Id) references FeedDistributor (FeedDistributor_Id)
  );

 create table Program_Format
 (Format_Id int,
  Asset_Id int,
  CONSTRAINT pk_Program_Format PRIMARY KEY (Format_Id, Asset_Id),
  CONSTRAINT fk_PF_Format_Id FOREIGN KEY (Format_Id) REFERENCES Format (Format_Id),
  CONSTRAINT fk_PF_asset_Id FOREIGN KEY (Asset_Id) REFERENCES Asset(Asset_Id)
  );

 create table Asset_TiVoKeyword
 (TiVoKeyword_id int,
  Asset_Id int,
  CONSTRAINT pk_ATK_TiVoKeyword PRIMARY KEY (TiVoKeyword_id, Asset_Id),
  CONSTRAINT fk_ATK_TiVoKeyword_id FOREIGN KEY (TiVoKeyword_id) REFERENCES TiVoKeyword (TiVoKeyword_id),
  CONSTRAINT fk_ATK_asset_Id FOREIGN KEY (Asset_Id) REFERENCES Asset(Asset_Id)
  );

 create table Asset_Keyword
 (Keyword_Id int,
  Asset_Id int,
  CONSTRAINT pk_AK_Keyword PRIMARY KEY (Keyword_Id, Asset_Id),
  CONSTRAINT fk_AK_Keyword_id FOREIGN KEY (Keyword_id) REFERENCES Keyword (Keyword_id),
  CONSTRAINT fk_AK_asset_Id FOREIGN KEY (Asset_Id) REFERENCES Asset (Asset_Id)
  );

 create table Asset_Genre
  (Genre_Id int,
   Asset_Id int,
   CONSTRAINT pk_AG_Keyword PRIMARY KEY (Genre_Id, Asset_Id),
   CONSTRAINT fk_AG_Genre_Id FOREIGN KEY (Genre_Id) REFERENCES Genre (Genre_Id),
   CONSTRAINT fk_AG_asset_Id FOREIGN KEY (Asset_Id) REFERENCES Asset (Asset_Id)
   );

 create table Asset_Talent
 (Talent_Id int,
  TalentRole_Id int,
  Asset_Id int,
  Talent_Detail Varchar(100),
  CONSTRAINT pk_AT_Talent PRIMARY KEY (Talent_Id, TalentRole_Id, Asset_Id),
  CONSTRAINT fk_AT_Talent_Id FOREIGN KEY (Talent_Id) REFERENCES Talent (Talent_Id),
  CONSTRAINT fk_AT_TalentRole_Id FOREIGN KEY (TalentRole_Id) REFERENCES TalentRole (TalentRole_Id),
  CONSTRAINT fk_AT_asset_Id FOREIGN KEY (Asset_Id) REFERENCES Asset(Asset_Id)
  );

 create table Asset_RelatedRights
 (Asset_Id_Source int,
  Asset_Id_Consumer int,
  AREL_IsConsumeRights numeric(1),
  CONSTRAINT pk_AR_Asset_Rel PRIMARY KEY (Asset_Id_Source, Asset_Id_Consumer),
  CONSTRAINT fk_AR_asset_Id_source FOREIGN KEY (Asset_Id_Source) REFERENCES Asset (Asset_Id),
  CONSTRAINT fk_AR_asset_Id_consumer FOREIGN KEY (Asset_Id_Consumer) REFERENCES Asset (Asset_Id)
  );

 create table ProgramSegment
 (Segment_Id int,
  Segment_Asset_Id int not null,
  Segment_Number int not null,
  Segment_Duration int,
  Segment_Note Varchar(268) /*blob*/,
  CONSTRAINT pk_ProgramSegment PRIMARY KEY (Segment_Id),
  CONSTRAINT fk_PS_segment_Asset_Id FOREIGN KEY (Segment_Asset_Id) REFERENCES Asset (Asset_Id)
  );
 
 create table ProgramSegment_SegmentCategory
 (Segment_Id int,
  SegmentCategory_Id int,
  CONSTRAINT pk_PSSC_Segment PRIMARY KEY (Segment_Id, SegmentCategory_Id),
  CONSTRAINT fk_PSSC_Segment_Id FOREIGN KEY (Segment_Id) REFERENCES ProgramSegment (Segment_Id),
  CONSTRAINT fk_PSSC_SegmentCategory_Id FOREIGN KEY (SegmentCategory_Id) REFERENCES SegmentCategory (SegmentCategory_Id)
  );

 create table Reup
 (Reup_Id int,
  Reup_BCastComment Varchar(268) /*blob*/, 
  Reup_SchoolRights Varchar(40), 
  Reup_SchoolOBDateMonths int, 
  Reup_SchoolOBDateDays int, 
  Reup_SchoolExpires date, 
  Reup_SchoolEachBroadcastMonths int, 
  Reup_SchoolEachBroadcastDays int, 
  Reup_NCCRights numeric(1), 
  Reup_LocalUnderwriting Varchar(80), 
  Reup_ProgramDescription  Varchar(268) /*blob*/,
  Reup_IsSeriesDesc numeric(1) not null, 
  Reup_Status Varchar(20), 
  Reup_Season Varchar(20), 
  Reup_LocalUnderwritingContact Varchar(80), 
  Reup_LocalUnderwritingPhone Varchar(20),
  CONSTRAINT pk_Reup PRIMARY KEY (Reup_Id)
  );

  create table Reup_Contact
  (Reup_Contact_Id int,
   Contact_Company_Id int not null,
   Contact_Reup_Id int,
   Contact_ContactType_Id int, 
   Contact_Name Varchar(40),
   Contact_Phone Varchar(20),
   CONSTRAINT pk_Reup_Contact PRIMARY KEY (Reup_Contact_Id),
   CONSTRAINT fk_RC_Contact_Company_Id FOREIGN KEY (Contact_Company_Id) REFERENCES Company (Company_Id),
   CONSTRAINT fk_RC_Contact_Reup_Id FOREIGN KEY (Contact_Reup_Id) REFERENCES Reup (Reup_Id),
   CONSTRAINT fk_RC_ContactType_Id FOREIGN KEY (Contact_ContactType_Id) REFERENCES ContactType (ContactType_Id)
   );

   create table Reup_Funder
   (Funder_Reup_Id int,
    Reup_Funder_Id int,
	Funder_Company_Id int,
	Funder_Start date,
	Funder_End date,
	Funder_Type Varchar(40),
	Funder_IsUnderwriting numeric(1), 
	Funder_IsSeason numeric(1) not null,
	CONSTRAINT pk_Reup_Funder PRIMARY KEY (Funder_Reup_Id, Reup_Funder_Id),
	CONSTRAINT fk_RF_Funder_Reup_Id FOREIGN KEY (Funder_Reup_Id) REFERENCES Reup (Reup_Id),
	CONSTRAINT fk_RF_Funder_Company_Id FOREIGN KEY (Funder_Company_Id) REFERENCES Company (Company_Id)
	);

 create table Asset_Rights
 (Rights_Id int,
  Rights_Rule_Id int not null,
  Rights_Asset_Id int not null,
  Rights_Reup_Id int not null,
  Rights_Group_Id int not null,
  Rights_Start date,
  Rights_End date,
  Rights_BlackoutStart date,
  Rights_BlackoutEnd date,
  Rights_DaysAvailable int,
  Rights_OBdate date,
  Rights_BlackoutStart2 date, 
  Rights_BlackoutEnd2 date,
  Rights_BlackoutStart3 date,
  Rights_BlackoutEnd3 date,
  CONSTRAINT pk_Asset_Rights PRIMARY KEY (Rights_Id),
  CONSTRAINT fk_AR_Rights_Rule_Id FOREIGN KEY (Rights_Rule_Id) REFERENCES Rights_Rule (Rule_Id),
  CONSTRAINT fk_AR_Rights_Asset_Id FOREIGN KEY (Rights_Asset_Id) REFERENCES Asset (Asset_Id),
  CONSTRAINT fk_AR_Rights_Reup_Id FOREIGN KEY (Rights_Reup_Id) REFERENCES Reup (Reup_Id),
  CONSTRAINT fk_AR_Rights_Group_Id FOREIGN KEY (Rights_Group_Id) REFERENCES Rights_Group (Group_Id)
  );

  /*
     P A C K A G E   L E V E L
  */

  create table PackageType
  (PackageType_id int,
   PackageType_Code char(6),
   PackageType_Description varchar(80),
   PackageType_IsArchived numeric(1) not null,
   CONSTRAINT pk_PackageType PRIMARY KEY (PackageType_id)
   );

  create table Rating
  (Rating_Id int,
   Rating_Code char(6),
   Rating_Description varchar(40),
   Rating_IsArchived numeric(1) not null,
   CONSTRAINT pk_Rating PRIMARY KEY (Rating_id)
   );

   create table Disclaimer
   (Disclaimer_Id int,
    Disclaimer_Code char(6),
	Disclaimer_Description varchar(80),
	Disclaimer_IsArchived numeric(1) not null,
	CONSTRAINT pk_Disclaimer PRIMARY KEY (Disclaimer_Id)
	);

   create table Attribute
   (Attribute_Id int,
    Attribute_Code char(6),
	Attribute_Description varchar(80),
	Attribute_IsArchived numeric(1) not null,
	CONSTRAINT pk_Attribute PRIMARY KEY (Attribute_Id)
	);
   
   create table FlagClass
   (FlagClass_Id int,
    FlagClass_Code char(6),
	FlagClass_Description varchar(80),
	CONSTRAINT pk_FlagClass PRIMARY KEY (FlagClass_Id)
	);
   
   create table FlagType
   (FlagType_Id int,
    FlagType_Code char(6),
	FlagType_Description varchar(80),
	FlagType_IsArchived numeric(1) not null,
	CONSTRAINT pk_FlagType PRIMARY KEY (FlagType_Id)
	);

   create table Element_Type
   (ElementType_Id int,
    ElementType_Code char(6) not null,
	ElementType_Description varchar(40) not null,
	ElementType_IsArchived numeric(1) not null,
	CONSTRAINT pk_ElementType PRIMARY KEY (ElementType_Id)
	);


   create table Package
   (Package_Id int,
    Package_Type_Id int,
	Package_VChip_Id int,
	Package_Rating_Id int,
	Package_Disclaimer_Id int,
	Package_Asset_Id int, 
	Package_Name varchar(80),
	Package_Duration int, 
	Package_Description Varchar(268) /*blob*/,
	Package_Number int not null, 
	Package_RevisionNumber int not null, 
	Package_IsTrueTime numeric(1) not null, 
	Package_AudioType varchar(6), 
	Package_HiDef varchar(5), 
	Package_CCCode varchar(6), 
	Package_IsDVI numeric(1) not null, 
	Package_SAPCode varchar(6), 
	Package_IsLive numeric(1) not null, 
	Package_AspectRatio varchar(10), 
	Package_PostLogo numeric(1), 
	Package_UsageStart date, 
	Package_UsageEnd date,
	Package_IsArchived numeric(1) not null, 
	Package_OldCode varchar(14), 
	Package_RatingStart int, 
	Package_ContentFlag numeric(1) not null, 
	Package_HouseNumber varchar(20), 
	Package_IsVChipEmbedded numeric(1) not null, 
	Package_IsEducational numeric(1), 
	Package_IsEducationalEmbedded numeric(1), 
	Package_IsPackage numeric(1), 
	Package_IsVariableDuration numeric(1), 
	Package_SubTitleLanguage varchar(6), 
	Package_Status varchar(20), 
	Package_MediaStatus varchar(80),
	CONSTRAINT pk_Package PRIMARY KEY (Package_id),
	CONSTRAINT fk_P_Package_Type FOREIGN KEY (Package_Type_Id) REFERENCES PackageType (PackageType_Id),
	CONSTRAINT fk_P_Package_VChip FOREIGN KEY (Package_VChip_Id) REFERENCES VChip (VChip_Id),
	CONSTRAINT fk_P_Package_Rating FOREIGN KEY (Package_Rating_Id) REFERENCES Rating (Rating_Id),
	CONSTRAINT fk_P_Package_Disclaimer FOREIGN KEY (Package_Disclaimer_Id) REFERENCES Disclaimer (Disclaimer_Id),
	CONSTRAINT fk_P_Package_Asset FOREIGN KEY (Package_Asset_Id) REFERENCES Asset (Asset_Id)
	);
	
   create table Package_Attribute
   (Attribute_id int,
    Package_id int,
	CONSTRAINT pk_Package_Attribute PRIMARY KEY (Attribute_id,Package_id),
	CONSTRAINT fk_PA_Attribute FOREIGN KEY (Attribute_id) REFERENCES Attribute (Attribute_id),
	CONSTRAINT fk_PA_Package FOREIGN KEY (Package_id) REFERENCES Package (Package_id)
   );

	create table Package_Flag
	(Flag_Screening_Id int,
	 Flag_PackageElement_Id int,
	 Flag_Package_Id int not null,
	 Flag_FlagType_Id int,
	 Flag_FlagClass_Id int,
	 Flag_TimeIn int,
	 Flag_TimeOut int,
	 Flag_Duration int,
	 Flag_Comment Varchar(268) /*blob*/,
	 CONSTRAINT pk_Package_Flag PRIMARY KEY (Flag_Screening_Id,Flag_PackageElement_Id),
	 CONSTRAINT fk_PF_Flag_Package FOREIGN KEY (Flag_Package_Id) REFERENCES Package (Package_Id),
	 CONSTRAINT fk_PF_Flag_FlagType FOREIGN KEY (Flag_FlagType_Id) REFERENCES FlagType (FlagType_Id),
	 CONSTRAINT fk_PF_Flag_FlagClass FOREIGN KEY (Flag_FlagClass_Id) REFERENCES FlagClass (FlagClass_Id)
	 );

	create table PackageElement
	(PackageElement_Id int,
	 PackageElement_Package_Id int not null,
	 PackageElement_Underwriting_Id int,
	 PackageElement_Asset_Id int,
	 PackageElement_ElementType_Id int not null,
	 PackageElement_Start int,
	 PackageElement_Duration int,
	 PackageElement_Required numeric(1) not null,
	 PackageElement_Description varchar(80),
	 CONSTRAINT pk_PackageElement PRIMARY KEY (PackageElement_Id),
	 CONSTRAINT fk_PE_Package FOREIGN KEY (PackageElement_Package_Id) REFERENCES Package (Package_Id),
	 CONSTRAINT fk_PE_ElementType FOREIGN KEY (PackageElement_ElementType_Id) REFERENCES Element_Type (ElementType_Id)
	 );


	/*
	   S C H E D U L E   L E V E L
	*/

	 create table FeedFlag
	 (FeedFlag_Id int,
	  FeedFlag_Description char(6),
	  FeedFlag_Code varchar(80),
	  FeedFlag_IsArchived numeric(1) not null,
	  CONSTRAINT pk_FeedFlag PRIMARY KEY (FeedFlag_Id)
	  );

	  create table Uplink
	  (Uplink_Id int,
	   Uplink_Description char(6),
	   Uplink_Code varchar(80),
	   Uplink_IsArchived numeric(1) not null,
	   CONSTRAINT pk_Uplink PRIMARY KEY (Uplink_Id)
	   );

	 create table Schedule
	 (Schedule_Id int,
	  Schedule_Package_Id int,
	  Schedule_Channel_Id int not null,
	  Schedule_Asset_Id int not null,
	  Schedule_Uplink_Id int,
	  Schedule_FeedFlag_Id int,
	  Schedule_Parent_Id int, 
	  Schedule_StartTime int, 
	  Schedule_Date date,
	  Schedule_Duration int, 
	  Schedule_DataTime datetime,
	  Schedule_CommonCarry numeric(1), 
	  Schedule_Class varchar(3), 
	  Schedule_JoinInProgress numeric(1) not null,
	  CONSTRAINT pk_Schedule PRIMARY KEY (Schedule_Id),
	  CONSTRAINT fk_S_Schedule_Package FOREIGN KEY (Schedule_Package_Id) REFERENCES Package (Package_Id),
	  CONSTRAINT fk_S_Schedule_Channel FOREIGN KEY (Schedule_Channel_Id) REFERENCES Channel (Channel_Id),
	  CONSTRAINT fk_S_Schedule_Asset FOREIGN KEY (Schedule_Asset_Id) REFERENCES Asset (Asset_Id),
	  CONSTRAINT fk_S_Schedule_Uplink FOREIGN KEY (Schedule_Uplink_Id) REFERENCES Uplink (Uplink_Id),
	  CONSTRAINT fk_S_Schedule_FeedFlag FOREIGN KEY (Schedule_FeedFlag_Id) REFERENCES FeedFlag (FeedFlag_Id)
	  );
