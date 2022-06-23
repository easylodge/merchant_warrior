module MerchantWarrior
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../../templates', __FILE__)
      desc 'Sets up the Merchant Warrior configuration File'

      # def copy_config
      #   template 'veda_credit.yml', 'config/veda_credit.yml'
      # end

      def self.next_migration_number(dirname)
        Time.new.utc.strftime('%Y%m%d%H%M%S')
      end

      def create_migration_file
        # copy migration
        migration_template 'create_merchant_warrior_payment_request.rb', 'db/migrate/create_merchant_warrior_payment_request.rb'
      end
    end
  end
end
