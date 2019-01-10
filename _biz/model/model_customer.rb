module YDAPI
  module BizModel
    class Model_Customer
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@customer = YDAPI::BizEntity::Customer
      @@customer_contact = YDAPI::BizEntity::CustomerContact

      @@customers = YDAPI::BizModel::DBModel::DAO_Customers
      @@customers_contacts = YDAPI::BizModel::DBModel::DAO_CustomersContacts

      @@dao_sql_customer = YDAPI::BizModel::DBModel::DAO_SQL_Customer

      def Model_Customer.add_new_customer(customer)
        if customer.is_a?(@@customer)
          new_id = @@helper.new_customer_id(@@customers.func_get_max_customer_id)
          if new_id != nil
            customer.customer_id = new_id
            @@logger.info("#{self}.add_new_customer, customer=#{customer}")
            @@customers.func_add(customer)
          else
            @@logger.error("#{self}.add_new_customer, get_max_user_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_customer, user is not a #{@@customer}")
          nil
        end
      end

      def Model_Customer.add_new_customer_contact(customer_contact)
        if customer_contact.is_a?(@@customer_contact)
          @@logger.info("#{self}.add_new_customer_contact, customer_contact=#{customer_contact}")
          @@customers_contacts.func_add(customer_contact)
        else
          @@logger.error("#{self}.add_new_customer_contact, customer_contact is not a #{@@customer_contact}")
          nil
        end
      end

      def Model_Customer.delete_customer_by_customer_id(customer_id)
        @@logger.info("#{self}.delete_customer_by_customer_id(#{customer_id})")
        @@customers.func_delete(customer_id)
      end

      def Model_Customer.delete_customer_contact_by_id(id)
        @@logger.info("#{self}.delete_customer_contact_by_id(#{id})")
        @@customers_contacts.func_delete(id)
      end

      def Model_Customer.update_customer(customer)
        @@logger.info("#{self}.update_customer, customer=#{customer}")
        @@customers.func_update(customer)
      end

      def Model_Customer.update_customer_contact(customer_contact)
        @@logger.info("#{self}.update_customer_contact, customer_contact=#{customer_contact}")
        @@customers_contacts.func_update(customer_contact)
      end

      def Model_Customer.get_customer_and_contacts_by_customer_id(customer_id)
        @@logger.info("#{self}.get_customer_and_contacts_by_customer_id(#{customer_id})")
        customer = @@customers.func_get(customer_id)
        if customer
          contacts = @@customers_contacts.func_get_all_to_one_customer(customer_id)
          contacts_array = []
          if contacts
            contacts.each {|row|
              contacts_array << row.values
            }
          end
          {:customer => customer.values, :contacts => contacts_array}
        else
          nil
        end
      end

      def Model_Customer.get_customers_by_user_name(user_name)
        @@logger.info("#{self}.get_customers_by_user_name(#{user_name})")
        # customers = @@customers.func_get_by_added_by_user_name(user_name)
        customers = @@dao_sql_customer.select_customers_by_user_name(user_name)
        if customers
          customers_array = []
          customers.each {|row|
            # customers_array << row.values
            customers_array << row
          }
          {:customers => customers_array}
        else
          nil
        end
      end

      def Model_Customer.get_customer_contact_id(id)
        @@logger.info("#{self}.get_customer_contact_id(#{id})")
        result = @@customers_contacts.func_get_by_id(id)
        if result
          result
        else
          nil
        end
      end

      def Model_Customer.get_all_customers(user_name)
        @@logger.info("#{self}.get_all_customers(#{user_name})")
        customers = @@customers.func_get_all
        if customers
          customers_array = []
          customers.each {|row|
            customers_array << row.values
          }
          {:customers => customers_array}
        else
          nil
        end
      end

      def Model_Customer.get_customers_by_id_arr(customer_id_arr)
        @@logger.info("#{self}.get_customers_by_id_arr(#{customer_id_arr})")
        customers = @@customers.func_get_by_id_arr(customer_id_arr)
        result={}
        if customers
          customers.each {|row|
            result[row[:customer_id]]=row.values
          }
          result
        else
          nil
        end
      end

      #  customer followup
      @@customer_followup = YDAPI::BizEntity::CustomerFollowup
      @@dao_customer_followup = YDAPI::BizModel::DBModel::DAO_CustomersFollowup

      def Model_Customer.add_new_customer_followup(customer_followup)
        if customer_followup.is_a?(@@customer_followup)
          @@logger.info("#{self}.add_new_customer_followup, customer_followup=#{customer_followup}")
          @@dao_customer_followup.func_add(customer_followup)
        else
          @@logger.error("#{self}.add_new_customer_followup, customer_contact is not a #{@@customer_followup}")
          nil
        end
      end

      def Model_Customer.delete_customer_followup_by_id(id)
        @@logger.info("#{self}.delete_customer_followup_by_id(#{id})")
        @@dao_customer_followup.func_delete(id)
      end

      def Model_Customer.update_customer_followup(customer_followup)
        @@logger.info("#{self}.update_customer_followup, customer_followup=#{customer_followup}")
        @@dao_customer_followup.func_update(customer_followup)
      end

      def Model_Customer.get_customer_followups_by_customer_id_user_name(customer_id,user_name)
        @@logger.info("#{self}.get_customer_followups_by_customer_id_user_name(#{customer_id},#{user_name})")
        customer_followups = @@dao_customer_followup.func_get_all_by_cid_uname(customer_id,user_name)
        if customer_followups
          customer_followups_array = []
          customer_followups.each {|row|
            customer_followups_array << row.values
          }
          {:customer_followups => customer_followups_array}
        else
          nil
        end
      end

      def Model_Customer.get_customer_followup_by_id(id)
        @@logger.info("#{self}.get_customer_followup_by_id(#{id})")
        customer_followup = @@dao_customer_followup.func_get_by_id(id)
        if customer_followup
          customer_followup
        else
          nil
        end
      end

      def Model_Customer.get_last_followup_status_by_cid_uname(customer_id,user_name)
        @@logger.info("#{self}.get_last_followup_status_by_cid_uname(#{customer_id},#{user_name})")
        followup_status = @@dao_sql_customer.get_last_followup_status_by_cid_uname(customer_id,user_name)
        if followup_status
          followup_status
        else
          "potential"
        end
      end
    end
  end
end