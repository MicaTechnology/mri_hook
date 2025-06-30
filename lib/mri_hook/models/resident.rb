# frozen_string_literal: true

module MriHook
  module Models
    class Resident
      attr_accessor :resident_name_id, :property_id, :building_id, :unit_id, :lease_id,
                    :resident_type, :status, :first_name, :last_name, :phone_number,
                    :email, :occupy_date, :last_update_date, :name_group,
                    :work_phone1, :work_phone2, :cell, :vacate_date,
                    :prospect_applicant_resident, :name_status, :birthday,
                    :middle_initial, :comment, :sex, :who, :qualified, :previous_residence,
                    :occupation, :income, :guarantor, :location, :marketing_id, :leasing_agent_id,
                    :company_name, :job_title, :job_years, :number_of_nsf_payments,
                    :number_of_late_payments, :payments_allowed, :user_id, :primary_name_id,
                    :residents_property_id, :lease_id, :identified_as_affordable_housing,
                    :date_placed_on_ah_waiting_list, :ah_waiting_list_sequence_number,
                    :marital_status, :previous_name_id, :size_of_unit, :query_flag,
                    :email_address, :status_based_on_credit_report_results, :public_assistance_id,
                    :fax, :tab_id, :move_in_reason, :number_of_residents, :ssno_not_available,
                    :background_check_status, :other_resident_background_check_required,
                    :follow_up_on_background_check, :no_checks_in_web_cash_receipts,
                    :occupant_inactive, :tax_credit_resident, :tax_credit_certified,
                    :auto_spread_concessions, :opt_out_of_check_scanning,
                    :exclude_resident_from_utility_billing, :utility_billing_override_date,
                    :record_created_by_call_center_agent, :renewal_lease_type,
                    :rent_increase_summary_type, :identified_as_student_housing,
                    :exclude_utility_billing, :social_security_number, :license_number,
                    :bank_account, :personal_phone, :employment_monthly_income,
                    :provider_screening_status

      # Initialize a new Resident object
      #
      # @param [Hash] params the parameters to initialize the object with
      def initialize(params = {})
        # Map fields from ResidentsByPropertyID endpoint
        # resident_name_id is used as a fallback for NameId in residents endpoint
        @resident_name_id = params['ResidentNameID'] || params['NameId']
        @property_id = params['RMPROPID'] || params['PropertyId']
        @building_id = params['RMBLDGID'] || params['BuildingId']
        @unit_id = params['UNITID'] || params['UnitId']
        @lease_id = params['RMLEASEID'] || params['LeaseId']
        @resident_type = params['ResidentType']
        @status = params['Status'] || params['NameStatus']
        @first_name = params['FirstName']
        @last_name = params['LastName']
        @phone_number = params['PhoneNumber']
        @email = params['Email']
        @occupy_date = params['OccupantOccupyDate']
        @last_update_date = params['LastUpdateDate'] || params['LastUpdate']
        @name_group = params['Namegroup']
        @work_phone1 = params['WorkPhone1']
        @work_phone2 = params['WorkPhone2']
        @cell = params['Cell']
        @vacate_date = params['VacateDate'] || params['OccupantVacateDate']

        # Map fields from Residents endpoint
        @prospect_applicant_resident = params['ProspectApplicantResident']
        @name_status = params['NameStatus']
        @birthday = params['Birthday']
        @middle_initial = params['MiddleInitial']
        @comment = params['Comment']
        @sex = params['Sex']
        @who = params['Who']
        @qualified = params['Qualified']
        @previous_residence = params['PreviousResidence']
        @occupation = params['Occupation']
        @income = params['Income']
        @guarantor = params['Guarantor']
        @location = params['Location']
        @marketing_id = params['MarketingId']
        @leasing_agent_id = params['LeasingAgentId']
        @company_name = params['CompanyName']
        @job_title = params['JobTitle']
        @job_years = params['JobYears']
        @number_of_nsf_payments = params['NumberOfNSFPayments']
        @number_of_late_payments = params['NumberOfLatePayments']
        @payments_allowed = params['PaymentsAllowed']
        @user_id = params['UserId']
        @primary_name_id = params['PrimaryNameId']
        @residents_property_id = params['ResidentsPropertyId']
        @identified_as_affordable_housing = params['IdentifiedAsAffordableHousing']
        @date_placed_on_ah_waiting_list = params['DatePlacedOnAHWaitingList']
        @ah_waiting_list_sequence_number = params['AHWaitingListSequenceNumber']
        @marital_status = params['MaritalStatus']
        @previous_name_id = params['PreviousNameId']
        @size_of_unit = params['SizeOfUnit']
        @query_flag = params['QueryFlag']
        @email_address = params['EMailAddress']
        @status_based_on_credit_report_results = params['StatusBasedOnCreditReportResults']
        @public_assistance_id = params['PublicAssistanceID']
        @fax = params['Fax']
        @tab_id = params['TabId']
        @move_in_reason = params['MoveInReason']
        @number_of_residents = params['NumberOfResidents']
        @ssno_not_available = params['SSNONotAvailable']
        @background_check_status = params['BackgroundCheckStatus']
        @other_resident_background_check_required = params['OtherResidentBackgroundCheckRequired']
        @follow_up_on_background_check = params['FollowUpOnBackgroundCheck']
        @no_checks_in_web_cash_receipts = params['NoChecksInWebCashReceipts']
        @occupant_inactive = params['OccupantInactive']
        @tax_credit_resident = params['TaxCreditResident']
        @tax_credit_certified = params['TaxCreditCertified']
        @auto_spread_concessions = params['AutoSpreadConcessions']
        @opt_out_of_check_scanning = params['OptOutOfCheckScanning']
        @exclude_resident_from_utility_billing = params['ExcludeResidentFromUtilityBilling']
        @utility_billing_override_date = params['UtilityBillingOverrideDate']
        @record_created_by_call_center_agent = params['RecordCreatedByCallCenterAgent']
        @renewal_lease_type = params['RenewalLeaseType']
        @rent_increase_summary_type = params['RentIncreaseSummaryType']
        @identified_as_student_housing = params['IdentifiedAsStudentHousing']
        @exclude_utility_billing = params['ExcludeUtilityBilling']
        @social_security_number = params['SocialSecurityNumber']
        @license_number = params['LicenseNumber']
        @bank_account = params['BankAccount']
        @personal_phone = params['PersonalPhone']
        @employment_monthly_income = params['EmploymentMonthlyIncome']
        @provider_screening_status = params['ProviderScreeningStatus']
      end

      # Get the full name of the resident
      #
      # @return [String] the full name
      def full_name
        "#{first_name} #{last_name}".strip
      end

      # Check if the resident is active
      #
      # @return [Boolean] true if the resident is active
      def active?
        status == 'R'
      end

      # Check if the resident is an owner
      #
      # @return [Boolean] true if the resident is an owner
      def owner?
        status == 'O'
      end
    end
  end
end
