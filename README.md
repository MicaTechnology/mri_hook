# MriHook

MriHook is a Ruby gem that provides a simple interface to interact with the MRI ERP API. It allows you to retrieve information from MRI and map the responses to Ruby objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mri_hook'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install mri_hook
```

## Configuration

MriHook requires the following environment variables to be set:

```ruby
ENV['BASE_MRI_DOMAIN'] = 'https://mrix5api.saas.mrisoftware.com'  # Default if not set
ENV['BASE_MRI_API_ENDPOINT'] = '/mriapiservices/api.asp'          # Default if not set
ENV['MRI_USERNAME'] = 'your_username'                             # Required
ENV['MRI_PASSWORD'] = 'your_password'                             # Required
```

You can create your own `.env.development` file in the root of your project to set these variables, or you can set them directly in your environment.
Below you can see how to "load" them in irb

## Usage
If run in IRB, important to run the following command to load the gem:

```ruby
require 'bundler/setup'
require 'mri_hook'
require 'dotenv'

Dotenv.load('.env.development')
```

### Getting Residents by Property ID

```ruby
# Create a handler for the residents by property endpoint
handler = MriHook::RequestHandlers::ResidentsByPropertyHandler.new

# Execute the request with the property ID
residents = handler.execute(property_id: 'GCNS01')

# Process the residents
residents.each do |resident|
  puts "Name: #{resident.full_name}"
  puts "Status: #{resident.status}"
  puts "Active: #{resident.active?}"
  puts "Owner: #{resident.owner?}"
  puts "Unit: #{resident.unit_id}"
  puts "---"
end
```

### Getting Residents by Various Parameters

The ResidentsHandler allows you to retrieve residents using different parameter combinations:

```ruby
# Create a handler for the residents endpoint
handler = MriHook::RequestHandlers::ResidentsHandler.new

# Option 1: Get residents by last update date
residents = handler.execute(last_update: '01-01-2024')

# Option 2: Get residents by name ID
residents = handler.execute(resident_name_id: '0000000298')

# Option 3: Get residents by date range
residents = handler.execute(start_date: '01-01-2024', end_date: '01-31-2024')

# Option 4: Get residents by property ID, type, and status
residents = handler.execute(property_id: 'GCNS01', type: 'R', status: 'O')

# You can also control whether to include PII (Personally Identifiable Information)
# By default, PII is included (include_pii: true)
residents = handler.execute(last_update: '01-01-2024', include_pii: false)

# Process the residents
residents.each do |resident|
  puts "Name: #{resident.full_name}"
  puts "Status: #{resident.status}"
  puts "Active: #{resident.active?}"
  puts "Owner: #{resident.owner?}"
  puts "Unit: #{resident.unit_id}"
  puts "---"
end
```

### Getting Resident Lease Details

The ResidentLeaseDetailsByPropertyHandler allows you to retrieve lease details for residents:

```ruby
# Create a handler for the resident lease details endpoint
handler = MriHook::RequestHandlers::ResidentLeaseDetailsByPropertyHandler.new

# Option 1: Get lease details by property ID
leases = handler.execute(property_id: 'GCNS01')

# Option 2: Get lease details by last update date
leases = handler.execute(last_update_date: '2020-02-25')

# Option 3: Get lease details by date range
leases = handler.execute(start_date: '2019-05-01', end_date: '2020-04-30')

# Process the lease details
leases.each do |lease|
  puts "Resident: #{lease.full_name}"
  puts "Property: #{lease.property_id}, Building: #{lease.building_id}, Unit: #{lease.unit_id}"
  puts "Lease Start: #{lease.lease_start}, Lease End: #{lease.lease_end}"
  puts "Monthly Rent: #{lease.monthly_rent} #{lease.curr_code}"
  puts "Current: #{lease.current?}, Month-to-Month: #{lease.month_to_month?}"
  puts "Has Pet: #{lease.has_pet?}"
  puts "---"
end
```

### Getting Open Charges

The OpenChargesHandler allows you to retrieve open charges for residents:

```ruby
# Create a handler for the open charges endpoint
handler = MriHook::RequestHandlers::OpenChargesHandler.new

# Option 1: Get open charges by property ID
charges = handler.execute(property_id: 'GCNS01')

# Option 2: Get open charges by last update date
charges = handler.execute(last_update: '2024-01-01')

# Option 3: Get open charges by property ID and resident ID
charges = handler.execute(property_id: 'GCNS01', resident_id: '0000000502')

# Process the open charges
charges.each do |charge|
  puts "Resident: #{charge.full_name}"
  puts "Property: #{charge.property_id}, Unit: #{charge.unit_unique_tag}"
  puts "Charge Date: #{charge.charge_date}, Description: #{charge.description}"
  puts "Charge Code: #{charge.charge_code} - #{charge.charge_code_description}"
  puts "Original Amount: #{charge.original_amount_value}, Unpaid Amount: #{charge.unpaid_amount_value}"
  puts "Late Fee: #{charge.late_fee?}, Auto-Generated: #{charge.auto_generated?}, Posted: #{charge.posted?}"
  puts "---"
end
```

### Getting Pending Move-Ins

The PendingMoveInsHandler allows you to retrieve information about residents who are scheduled to move in:

```ruby
# Create a handler for the pending move-ins endpoint
handler = MriHook::RequestHandlers::PendingMoveInsHandler.new

# Get pending move-ins by property ID
pending_move_ins = handler.execute(property_id: 'GCCH02')

# Process the pending move-ins
pending_move_ins.each do |move_in|
  puts "Resident: #{move_in.full_name}"
  puts "Property: #{move_in.property_id}, Building: #{move_in.building_id}, Unit: #{move_in.unit_id}"
  puts "Scheduled Move-In Date: #{move_in.scheduled_move_in_date}"
  puts "Email: #{move_in.email}"

  # Access previous address information if available
  if move_in.primary_previous_address
    puts "Previous Address: #{move_in.primary_previous_address.full_address}"
  end

  puts "---"
end
```

### Getting Resident Ledger Transactions

The ResidentLedgerHandler allows you to retrieve ledger transactions for a resident:

```ruby
# Create a handler for the resident ledger endpoint
handler = MriHook::RequestHandlers::ResidentLedgerHandler.new

# Get ledger transactions for a resident
# Note: All parameters are required and dates must be in yyyy-mm-dd format
transactions = handler.execute(
  start_date: '2024-01-01',
  end_date: '2025-06-30',
  resident_name_id: '0000009006',
  property_id: 'GCCH01'
)

# Process the ledger transactions
transactions.each do |transaction|
  puts "Transaction ID: #{transaction.transaction_id}"
  puts "Date: #{transaction.transaction_date}"
  puts "Description: #{transaction.description}"
  puts "Amount: #{transaction.transaction_amount_value}"
  puts "Type: #{transaction.payment? ? 'Payment' : (transaction.charge? ? 'Charge' : 'Other')}"
  puts "Posted: #{transaction.posted? ? 'Yes' : 'No'}"
  puts "---"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mri_hook. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/mri_hook/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the MriHook project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/mri_hook/blob/main/CODE_OF_CONDUCT.md).
